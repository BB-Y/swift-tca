//
//  SDSetNewPassword.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/8.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SDSetNewPasswordReducer.self)
struct SDSetNewPasswordView: View {
    @Perception.Bindable var store: StoreOf<SDSetNewPasswordReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            
            Group {
                SDVSpacer(48)

                Text(titleForScene)
                    .font(.largeTitle.bold())
                    .foregroundStyle(SDColor.text1)
               
                SDVSpacer(32)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 24) {
                // 仅在通过旧密码重置时显示旧密码输入框
                if store.scene == .resetByOld {
                    SDSecureField("请输入旧密码", text: $store.oldPassword, isSecure: true)
                        .padding(.horizontal, 16)
                        .background {
                            SDColor.background
                                .clipShape(Capsule())
                        }
                }
                
                SDSecureField("请输入新密码", text: $store.password, isSecure: true)
                    .padding(.horizontal, 16)
                    .background {
                        SDColor.background
                            .clipShape(Capsule())
                    }
                SDSecureField("请再次输入密码", text: $store.confirmPassword, isSecure: true)
                    .padding(.horizontal, 16)
                    .background {
                        SDColor.background
                            .clipShape(Capsule())
                    }
                
            }
            SDVSpacer(16)
            VStack(spacing: 0) {
                Text("请输入6-16位密码，包含数字或字母")
                    .foregroundStyle(SDColor.text3)
                    .font(.sdSmall1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SDVSpacer(20)

                Text(store.errorMsg)
                    .foregroundStyle(SDColor.error)
                    .font(.sdSmall1)
                SDVSpacer(2)

                Button {
                    send(.submitButtonTapped)
                } label: {
                    if store.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(buttonTextForScene)
                    }
                }
        
                .buttonStyle(.sdConfirm(isDisable: !store.canSubmit))
            }
            
            Spacer()
        }
        .padding(.horizontal, 40.pad(134))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    // 根据场景返回不同的标题
    private var navigationTitle: String {
        switch store.scene {
        case .resetByForget:
            return ""
        case .resetByCode:
            return "设置新密码"
        case .resetByOld:
            return "设置新密码"
        }
    }
    // 根据场景返回不同的标题
    private var titleForScene: String {
        switch store.scene {
        case .resetByForget:
            return "重置密码"
        case .resetByCode:
            return "请输入密码"
        case .resetByOld:
            return "设置新密码"
        }
    }
    
    // 根据场景返回不同的按钮文本
    private var buttonTextForScene: String {
        switch store.scene {
        case .resetByForget, .resetByCode:
            return "确定"
        case .resetByOld:
            return "确定"
        }
    }
}

#Preview {
    NavigationStack {
        SDSetNewPasswordView(
            store: Store(
                initialState: SDSetNewPasswordReducer.State(
                    scene: .resetByOld,
                    phone: "19992223333",
                    code: "999999"
                ),
                reducer: { SDSetNewPasswordReducer() }
            )
        )
    }
}
