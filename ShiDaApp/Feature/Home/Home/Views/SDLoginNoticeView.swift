//
//  SDLoginNoticeView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/21.
//

import SwiftUI

struct SDLoginNoticeView: View {
    let onTap: () -> Void
    var body: some View {
        HStack {
            Text("登录体验更多精彩内容！")
                .font(.sdBody2)
                .foregroundStyle(Color.white)
            Spacer()
            Button {
                onTap()
            } label: {
                Text("立即登录")
                    .font(.sdBody3)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 32)
            }
            .buttonStyle(.sdSmall())
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background {
            SDColor.text1.opacity(0.8)
        }
    }
}

#Preview {
    SDLoginNoticeView(onTap: {})
}
