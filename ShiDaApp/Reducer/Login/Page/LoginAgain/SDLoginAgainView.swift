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
        
        @Shared(.shareAcceptProtocol) var accept = false
        
        var showProtocol = false
        var isPush = false
    }
    
    enum Action {
        
        case onLoginTapped
        case onOtherLoginTapped
        case onAcceptTapped
        
        case onAcceptContinueTapped

        
    }
    
    var body: some ReducerOf<Self> {
        

        Reduce { state, action in
            switch action {
                
            case .onLoginTapped:
                if state.accept == false {
                    state.showProtocol = true
                    return .none

                } else{
                    //TODO: 接口
                    return .none
                }
               
            case .onOtherLoginTapped:
                
                return .none
            case .onAcceptTapped:
                let newAccept = !state.accept
                state.$accept.withLock({$0 = newAccept})
                return .none
           
            case .onAcceptContinueTapped:
                state.$accept.withLock({$0 = true})
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
            VStack(spacing: 16) {
                // 头像
                Image("login_weixin") // 这里应该替换为用户头像
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                     Circle()
                         .stroke(SDColor.accent, lineWidth: 2)
                    )
                    .padding(.top, 40)
                
                // 用户名
                Text("逆风的少年") // 这里应该替换为实际用户名
                    .font(.title2)
                    .foregroundStyle(SDColor.text1)
                Button {
                    store.send(.onLoginTapped)
                } label: {
                    Text("登录此帐号")

                }
                .buttonStyle(SDButtonStyleConfirm())

                Button {
                    store.send(.onOtherLoginTapped)
                } label: {
                    Text("其他登录方式")

                }
                .buttonStyle(SDButtonStyleConfirm())
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
            
        }
//        .background {
//            Color.red
//        }
    }
}

//#Preview {
//    SDLoginAgainView()
//}
