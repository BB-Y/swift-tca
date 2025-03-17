//
//  SDLoginView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

@ViewAction(for: SDLoginReducer.self)
struct SDLoginView: View {
    @Perception.Bindable var store: StoreOf<SDLoginReducer>
    
   
    
    // 根据登录方式返回密码输入框占位符
    var passwordPlaceholder: String {
        store.isSMSLogin ? "请输入验证码" : "请输入密码"
    }
    
    var title: String {
        return store.isSMSLogin ? "验证码登录" : "密码登录"
    }
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                
                    
                VStack(spacing: 0) {
                    // 标题部分
                    titleSection
                    
                    Spacer()
                        .frame(height: 16)
                    
                    // 输入部分
                    inputSection
                    
                    Spacer()
                        .frame(height: 16)
                    
                    // 登录方式切换部分
                    loginTypeToggleSection
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // 登录按钮部分
                    loginButtonSection
                    
                    Spacer()
                        .frame(height: 24)
                    
                    // 协议部分
                    protocolSection
                    
                    
                    
                    Spacer()
                        .frame(height: 90)

                    // 其他登录方式部分
                    otherLoginMethodsSection
                        
                        
                    

                    
                    //                Spacer()
                    //                    .frame(height: 100)
                    
                    
                }
            }
            
            .frame(maxHeight: .infinity, alignment: .top)
            .scrollIndicators(.hidden)
            .padding(.horizontal, 40.pad(134))
            
            // 添加协议弹窗
            .sheet(isPresented: $store.showProtocolSheet) {
                WithPerceptionTracking {
                    SDProtocolConfirmView {
                        send(.onProtocolConfirmed)
                    }
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
                }
            }
            .navigationTitle("")
            .ignoresSafeArea(.keyboard, edges:  .bottom)
            //.ignoresSafeArea(edges: .bottom)
        }
        
        
    }
    
    // MARK: - 视图组件
    
    // 标题部分
    private var titleSection: some View {
        VStack(spacing: 0) {
            
            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(SDColor.text1)
                .padding(.top, 48)
                .padding(.bottom, 4)
            
                
            bottomTextSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    // 输入部分
    private var inputSection: some View {
        VStack(spacing: 24) {
            SDPhoneInputView("请输入手机号", phone: $store.phone)
            
            
            
            HStack {
                SDSecureField(passwordPlaceholder, text: $store.password, isSecure: !store.isSMSLogin)
                                
                if store.isSMSLogin {
                    Button {
                        send(.onSendCodeTapped)
                    } label: {
                        Text(store.defaultButtonTitle)
                            .font(.sdBody3)
                    }
                    .buttonStyle(SDButtonStyleDisabled())
                    .disabled(store.sendCodeState.isCounting)
                }
            }
            .padding(.horizontal, 16)
            .background {
                SDColor.background
                    .clipShape(Capsule())
            }
        }
    }
    
    // 登录方式切换部分
    private var loginTypeToggleSection: some View {
        HStack {
            Button(action: {
                send(.onToggleLoginTypeTapped)
            }) {
                HStack(spacing: 2) {
                    Text(store.isSMSLogin ? "密码登录" : "验证码登录")
                    Image("icon_switch_password")
                }
            }
            .foregroundStyle(SDColor.text3)
           
            Spacer()
            
            if !store.isSMSLogin {
                Button("忘记密码?") {
                    send(.onForgetTapped)
                }
            }
        }
        .font(.sdBody3)
    }
    
    // 登录按钮部分
    private var loginButtonSection: some View {
        VStack(spacing: 14) {
            Text(store.errorMsg)
                .frame(height: 10)
                .font(.sdBody3)
                .foregroundStyle(SDColor.error)
            Button {
                send(.onLoginTapped)
            } label: {
                if store.isLoading {
                    ProgressView()
                } else {
                    Text("登录")
                }

                
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: store.isLoading || !store.isValid))
        }
    }
    
    // 协议部分
    private var protocolSection: some View {
        SDProtocoView(accept: Binding(get: {
            store.acceptProtocol
        }, set: { value in
            send(.onProtocolTapped)
        }))
    }
    
    // 其他登录方式部分
    private var otherLoginMethodsSection: some View {
        VStack(spacing: 24) {
            HStack {
                SDLine(SDColor.divider)
                Text("其它登录方式")
                    .font(.sdSmall1)
                    .foregroundStyle(SDColor.text3)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                SDLine(SDColor.divider)
            }
            .frame(width: 200)
            HStack(spacing: 40){
                Image("login_weixin")
                Image("login_qq")
               
                Image("login_apple")
                    .onTapGesture {
                        AppleLoginService.shared.startLogin(with: .apple) {_ in 
                            
                        }
                    }
            }
            
//            SignInWithAppleButton(.continue,
//                        onRequest: { request in
//                            
//                        },
//                        onCompletion: { result in
//                            
//                        }
//                    )
//            //.signInWithAppleButtonStyle(.black)
//            .frame(width: 66,height: 66)
//            .clipShape(Capsule())
        }
    }
    
    // 底部文本部分
    private var bottomTextSection: some View {
        Text("未注册的手机登录后会自动注册")
            .foregroundStyle(SDColor.text3)
            .font(.sdSmall1)
            .hidden(!store.isSMSLogin)
    }
}

#Preview {
    NavigationStack {
        WithPerceptionTracking {
            SDLoginView(store: Store(initialState: SDLoginReducer.State(), reducer: {
                SDLoginReducer()
                    ._printChanges()
            }))
            .navigationTitle("")
        }
    }
    .tint(SDColor.accent)
}









