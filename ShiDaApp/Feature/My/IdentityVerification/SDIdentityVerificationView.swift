//
//  SDIdentityVerificationView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture



struct SDVerificationTypeView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            SDVSpacer(16)
            NavigationLink(state: MyFeature.Path.State.codeValidate(SDValidateCodeReducer.State(phone: "", sendCodeType: .changePassword))) {
                HStack {
                    Text("手机验证码")
                        .font(.sdBody1.weight(.medium))
                        .foregroundStyle(SDColor.text1)
                    Spacer()
                    Image("arrow_right")
                }
                .frame(height: 54)
            }
            SDLine(SDColor.divider1)
            NavigationLink(state: MyFeature.Path.State.password(SDSetNewPasswordReducer.State(scene: .resetByOld))) {
                HStack {
                    Text("原密码验证")
                        .font(.sdBody1.weight(.medium))
                        .foregroundStyle(SDColor.text1)
                    Spacer()
                    Image("arrow_right")
                }
                .frame(height: 54)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationTitle("身份认证")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 18.0, *)
#Preview {
    SDVerificationTypeView()
}
