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

                Text("重置密码")
                    .font(.largeTitle.bold())
                    .foregroundStyle(SDColor.text1)
               
                SDVSpacer(32)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 24) {
                
                
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
                        Text("确定")
                    }
                }
        
                .buttonStyle(SDButtonStyleConfirm(isDisable: !store.canSubmit))
            }
            
            
            
            Spacer()
        }
        .padding(.horizontal, 40.pad(134))
        
    }
}

#Preview {
    NavigationStack {
        SDSetNewPasswordView(
            store: Store(
                initialState: SDSetNewPasswordReducer.State(phone: "19992223333", code: "999999"),
                reducer: { SDSetNewPasswordReducer() }
            )
        )
    }
}
