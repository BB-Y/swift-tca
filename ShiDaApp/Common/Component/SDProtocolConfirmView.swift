//
//  SDProtocolConfirmView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

// 协议确认视图
struct SDProtocolConfirmView: View {
    var onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            Text("请阅读并同意以下条款")
                .font(.sdBody1)
                .padding(.vertical, 20)
            SDVSpacer(28)
            SDLinkTextView(segments: [
                .link("《用户协议》", url: "https://baidu.com"),
                .link("《隐私政策》", url: "https://baidu.com"),
                .link("《儿童/青少年个人信息保护政策》", url: "https://baidu123.com")
            ])
            .font(.sdBody3)
            .lineSpacing(8)
            
            SDVSpacer(40)

            Button {
                onConfirm()
            } label: {
                Text("同意并继续")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SDButtonStyleConfirm())
            
            Spacer()
            
        }
        .padding(.horizontal, 40)

        .background(Color.white)
        .withCloseButton {
            dismiss()
        }
    }
}
