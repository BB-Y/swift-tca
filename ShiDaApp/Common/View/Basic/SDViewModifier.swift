//
//  SDViewModifier.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDTextFieldWithClearButtonModefier : ViewModifier {
    @Binding var text: String
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .onTapGesture {
                        text = ""
                    }
            }
            
        }
        
    }
    
}

// 添加关闭按钮修饰符
struct SDCloseButtonModifier: ViewModifier {
    var action: () -> Void
    var padding: CGFloat = 16
    var size: CGFloat = 24
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            
            SDCloseButton(size: size, action: action)
                .padding(padding)
        }
    }
}

// 扩展View以添加关闭按钮的便捷方法
extension View {
    func withCloseButton(padding: CGFloat = 16, size: CGFloat = 24, action: @escaping () -> Void) -> some View {
        self.modifier(SDCloseButtonModifier(action: action, padding: padding, size: size))
    }
}
