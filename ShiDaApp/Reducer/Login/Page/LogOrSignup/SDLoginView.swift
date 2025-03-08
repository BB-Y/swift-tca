//
//  SDLoginView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture

struct SDLoginView: View {
    @Perception.Bindable var store: StoreOf<SDLoginReducer>
    @State private var isFlipping = false
    
    var body: some View {
        WithPerceptionTracking {
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
                    .frame(height: 30)
                
                // 登录按钮部分
                loginButtonSection
                
                Spacer()
                    .frame(height: 24)
                
                // 协议部分
                protocolSection
                
                
                
                Spacer()
                
                // 其他登录方式部分
                otherLoginMethodsSection
                
                Spacer()
                    .frame(height: 100)
                
                
            }
            .padding(.horizontal, 40.pad(134))
            //        .background(content: {
            //            Color.blue
            //        })
            
            // 添加协议弹窗
            .sheet(isPresented: $store.showProtocolSheet) {
                WithPerceptionTracking {
                    SDProtocolConfirmView {
                        store.send(.onProtocolConfirmed)
                    }
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
                }
            }
            .navigationTitle("")
        }
        
        
    }
    
    // MARK: - 视图组件
    
    // 标题部分
    private var titleSection: some View {
        Group {
            Spacer()
                .frame(height: 48)
            Text(store.title)
                .font(.largeTitle.bold())
                .foregroundStyle(SDColor.text1)
            Spacer()
                .frame(height: 4)
                
            bottomTextSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    // 输入部分
    private var inputSection: some View {
        Group {
            SDPhoneInputView("请输入手机号", phone: $store.phone, nationCode: $store.nationCode)
            
            Spacer()
                .frame(height: 24)
            
            HStack {
                SDSecureField(store.passwordPlaceholder, text: $store.password, isSecure: !store.isSMSLogin)
                                    
                if store.showSendCode {
                    Button {
                        store.send(.onSendCodeTapped)
                    } label: {
                        Text(store.sendButtonText)
                            .font(.sdBody3)
                    }
                    .buttonStyle(SDButtonStyleDisabled())
                    .disabled(store.countDownState.isCounting == true)
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
                store.send(.onToggleLoginTypeTapped)
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
                    store.send(.onForgetTapped)
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
                store.send(.onLoginTapped)
            } label: {
                Text(store.buttonTitle)
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: store.isLoading || !store.isValid))
        }
    }
    
    // 协议部分
    private var protocolSection: some View {
        SDProtocoView(accept: Binding(get: {
            store.acceptProtocol
        }, set: { value in
            store.$acceptProtocol.withLock{$0 = value}
        }))
    }
    
    // 其他登录方式部分
    private var otherLoginMethodsSection: some View {
        VStack(spacing: 40) {
            HStack(spacing: 40){
                Image("login_weixin")
                Image("login_qq")
                Image("login_apple")
            }
            .background(alignment: .top) {
                HStack {
                    SDLine(SDColor.divider)
                    Text("其它登录方式")
                        .font(.sdSmall1)
                        .foregroundStyle(SDColor.text3)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                    SDLine(SDColor.divider)
                }
                .offset(x:0, y: -50)
            }
        }
    }
    
    // 底部文本部分
    private var bottomTextSection: some View {
        Text("未注册的手机登录后会自动注册")
            .foregroundStyle(SDColor.text3)
            .font(.sdSmall1)
    }
}

#Preview {
    NavigationStack {
        WithPerceptionTracking {
            SDLoginView(store: Store(initialState: SDLoginReducer.State(), reducer: {
                SDLoginReducer()
            }))
            .navigationTitle("")
        }
    }
    .tint(SDColor.accent)
}









