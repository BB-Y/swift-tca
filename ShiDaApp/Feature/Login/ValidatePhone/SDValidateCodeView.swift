//
//  SDValidateCodeView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/9.
//

import SwiftUI

struct SDValidateCodeView: View {
    @Perception.Bindable var store: StoreOf<SDValidateCodeReducer>
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .center,spacing: 0) {
                Spacer()
                    .frame(height: 48)
                SDLargeTitleView("请输入验证码")
                Spacer()
                    .frame(height: 8)
                Text("已发送6位验证码至 +\(store.nation) \(store.phone)")
                    .font(.sdBody3)
                    .foregroundStyle(SDColor.text3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 32)
                VerificationCodeView(code: $store.code)
                
                Spacer()
                    .frame(height: 40)
                Button {
                    store.send(.onConfirmTapped)
                } label: {
                    WithPerceptionTracking {
                        Text("确定")
                    }
                }
                .buttonStyle(.sdConfirm(isDisable: !store.isValidCode))
                Spacer()
                    .frame(height: 24)
                Button {
                    store.send(.onSendAgainTapped)
                } label: {
                    WithPerceptionTracking {
                        Text(store.isCounting ? "重新发送(\(store.currentNumber)s)" : "重新发送")

                    }
                }
                .font(.sdBody1)
                .buttonStyle(SDButtonStyleDisabled())
                .disabled(store.isCounting == true)
                
                Spacer()
            }
            .hideKeyboardWhenTap()
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbarRole(.editor)
            .padding(.horizontal, 40)
            .onDisappear {
                store.send(.onDisappear)
            }
        }
       
        
    }
}


//#Preview {
//    SDValidateCodeView()
//}
