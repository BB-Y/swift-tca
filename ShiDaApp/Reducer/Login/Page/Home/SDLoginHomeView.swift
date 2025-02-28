//
//  SDLoginHomeView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture

//登录首页
struct SDLoginHomeView: View {
    @Perception.Bindable var store: StoreOf<SDLoginHomeReducer>
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
        } destination: { state in
            switch state.case {
            case .login(let store):
                SDLoginView(store: store)
            case .signup(let store):
                SDSignupView(store: store)
            case .phoneValidate(let store):
                SDValidatePhoneView(store: store)
            }
        }
    }
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            Spacer()
           Image("logo_large")
            Spacer()
            if store.token.isEmpty, store.userInfoModel != nil, !store.shouldShowLoginAndSignup {
                loggedInContent
                
            } else {
                notLoginContent
            }
            

            
            Spacer()
                .frame(height: 115)
        }
        .padding()
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    store.send(.showHome)
                }) {
                    Image("close")
                }
            }
        }
    }
    // 未登录状态的视图
    @ViewBuilder
    private var notLoginContent: some View {
        VStack(spacing: 16) {
            Button {
                store.send(.showLogin)
            } label: {
                HStack {
                    Image("icon_login")
                    Text("登录")
                }
            }
            .buttonStyle(SDButtonStyleConfirm())
            Button {
                store.send(.showSignup)
            } label: {
                HStack {
                    Image("icon_signup_student")
                    Text("学生注册")
                }
            }
            .buttonStyle(SDButtonStyleGray())
            Button {
                store.send(.showSignup)
            } label: {
                HStack {
                    Image("icon_signup_teacher")
                    Text("教师注册")
                }
            }
            .buttonStyle(SDButtonStyleGray())
        }
        .padding(.horizontal, 40.pad(134))
    }
    
    // 登录后再退出状态的视图
       @ViewBuilder
       private var loggedInContent: some View {
           VStack(spacing: 0) {
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
                       store.send(.showLogin)
                   } label: {
                       Text("登录此帐号1")

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
       }
    
   

}

#Preview {
    SDLoginHomeView(store: .init(initialState: .init(), reducer: {
        SDLoginHomeReducer.init()
    }))
}
