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
    @ObservableState
    struct State: Equatable {
        
        var userAvator: String = ""
        var userName: String = ""
        
        @Shared(.shareAcceptProtocol) var acceptProtocol = false

        var showProtocol = false
        var isPush = false
    }
    
    enum Action {
        
        case onLoginTapped
        case onOtherLoginTapped
        
        
        case onAcceptContinueTapped
        
        
    }
    
    var body: some ReducerOf<Self> {
        
        
        Reduce { state, action in
            switch action {
                
            case .onLoginTapped:
                if state.acceptProtocol == false {
                    state.showProtocol = true
                    return .none
                    
                } else{
                    //TODO: 接口
                    return .none
                }
                
            case .onOtherLoginTapped:
                
                return .none
           
                
            case .onAcceptContinueTapped:
                state.$acceptProtocol.withLock({$0 = true})
                return .send(.onLoginTapped)
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
                    Text("逆风的少年") // 这里应该替换为实际用户名
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
