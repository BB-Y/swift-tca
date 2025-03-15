//
//  SDLoginAgainView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import SwiftUI
import ComposableArchitecture
import CodableWrappers

@Reducer
struct SDLoginAgainReducer {
    @Dependency(\.userClient) var userClient
    @Dependency(\.authClient) var authClient
    @ObservableState
    struct State: Equatable {
        var userAvator: String = ""
        var userName: String = ""
        
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        @Shared(.shareUserInfo) var userInfo = nil

        var showProtocol: Bool = false
        var isPush = false
        
        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
    }
    
    enum Action: BindableAction {  // 添加 BindableAction
        case binding(BindingAction<State>)  // 添加这一行
        case onLoginTapped
        case onOtherLoginTapped
        case onAcceptContinueTapped
        case getUserInfoResponse(Result<SDResponseUserInfo, Error>)
        
        
        case oneKeyLoginResponse(Result<SDResponseLogin, Error>)

        // 父级处理的 Action
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case userTypeNil
            case loginSuccess
            case switchToOtherLogin
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()  // 添加这一行
        Reduce { state, action in
            switch action {
            case .delegate(_):
                return .none
            case .onLoginTapped:
                if state.acceptProtocol == false {
                    state.showProtocol = true
                    return .none
                } else {
                    if let phone = state.userInfoModel?.phone {
                        return .run { send in
                            await send(.oneKeyLoginResponse(Result {
                                try await authClient.oneKeyLogin(phone)
                            }))
                        }
                    }
                    
                }
                return .none

                
            case let .getUserInfoResponse(.success(response)):
                if response.userType == nil {
                    return .send(.delegate(.userTypeNil))
                } else {
                    return .send(.delegate(.loginSuccess))
                }
                
            case .getUserInfoResponse(.failure):
                // 处理错误情况，可以添加错误提示
                return .none
                
            case .onOtherLoginTapped:
                return .send(.delegate(.switchToOtherLogin))
            
                return .none
           
                
            case .onAcceptContinueTapped:
                state.showProtocol = false
                state.$acceptProtocol.withLock({$0 = true})
                return .send(.onLoginTapped)
            case .binding(_):
                return .none
            case .oneKeyLoginResponse(let result):
                switch result {
                    
                case .success(let response):
                    if response.userType == nil {
                        return .send(.delegate(.userTypeNil))
                    } else {
                        return .send(.delegate(.loginSuccess))
                    }
                case .failure(_):
                    return .none

                }
                return .none

            }
        }
    }
}

struct SDLoginAgainView: View {
    @Perception.Bindable var store: StoreOf<SDLoginAgainReducer>
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer()
            Image("logo_large")
            Spacer()
            // 用户头像和信息
            VStack(spacing: 24) {
                // 头像
                VStack(spacing: 16) {
                    Circle()
                        .fill(SDColor.accent)
                        .frame(width: 56, height: 56)
                        .overlay {
                            Image("login_qq") // 这里应该替换为用户头像
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        }
                    
                        
                    // 用户名
                    Text(store.userInfoModel?.name ?? "") // 这里应该替换为实际用户名
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text1)
                }
                
                
                Button {
                    store.send(.onLoginTapped)
                } label: {
                    Text("登录此帐号")
                    
                }
                .buttonStyle(SDButtonStyleConfirm())
                
                Button {
                    store.send(.onOtherLoginTapped)
                } label: {
                    Text("其他登录方式>")
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text3)
                }
            }
            .frame(maxWidth: .infinity)
            SDVSpacer(40)
            SDProtocoView(accept: Binding(get: {
                store.acceptProtocol
            }, set: { value in
                store.$acceptProtocol.withLock{$0 = value}
            }))
            

            
        }
        .padding(.horizontal, 40.pad(134))
        
        .sheet(isPresented: $store.showProtocol) {
            WithPerceptionTracking {
                SDProtocolConfirmView {
                    store.send(.onAcceptContinueTapped)
                }
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.hidden)
            }
        }
        //        .background {
        //            Color.red
        //        }
    }
}

#Preview {
    SDLoginAgainView(store: .init(initialState: SDLoginAgainReducer.State(), reducer: {
        SDLoginAgainReducer()
    }))
}
