//
//  SDAlertView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import SwiftUI
import PopupView

/// 按钮样式枚举
public enum SDAlertButtonStyle {
    case `default`
    case cancel
    case destructive
}

/// 按钮模型
public struct SDAlertButton {
    let title: String
    let style: SDAlertButtonStyle
    let action: () -> Void
    
    public init(title: String, style: SDAlertButtonStyle = .default, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}

struct SDAlertView: View {
    let title: String
    let message: String?
    let buttons: [SDAlertButton]
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题和消息
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // 分隔线
            Divider()
            
            // 按钮
            buttonLayout
        }
        .background(Color.background)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 70)
    }
    
    @ViewBuilder
    private var buttonLayout: some View {
        if buttons.count <= 2 {
            // 1-2个按钮水平排列
            HStack(spacing: 0) {
                ForEach(0..<buttons.count, id: \.self) { index in
                    buttonView(for: buttons[index])
                    
                    if index < buttons.count - 1 {
                        Divider()
                    }
                }
            }
            .frame(height: 44)
        } else {
            // 3个及以上按钮垂直排列
            VStack(spacing: 0) {
                ForEach(0..<buttons.count, id: \.self) { index in
                    buttonView(for: buttons[index])
                    
                    if index < buttons.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func buttonView(for button: SDAlertButton) -> some View {
        Button(action: {
            isPresented = false
            button.action()
        }) {
            Text(button.title)
                .font(.system(size: 17, weight: button.style == .cancel ? .semibold : .regular))
                .frame(maxWidth: .infinity)
                .foregroundColor(buttonColor(for: button.style))
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 44)
    }
    
    private func buttonColor(for style: SDAlertButtonStyle) -> Color {
        switch style {
        case .default:
            return SDColor.accent
        case .cancel:
            return SDColor.text1
        case .destructive:
            return SDColor.warning
        }
    }
}

// 用于在 SwiftUI 中显示 Alert 的修饰器
public struct SDAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let buttons: [SDAlertButton]
    
    public func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented) {
                SDAlertView(
                    title: title,
                    message: message,
                    buttons: buttons,
                    isPresented: $isPresented
                )
                    
            } customize: {
                $0
                    .type(.toast)
                    .displayMode(.sheet)
                    .position(.center)
                    .appearFrom(.centerScale)
                    .backgroundColor(Color.black.opacity(0.2))
                    .animation(.easeInOut)
            }
    }
}

// 扩展 View 以便于使用
public extension View {
    func sdAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        buttons: [SDAlertButton]
    ) -> some View {
        self.modifier(SDAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            buttons: buttons
        ))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showAlert = true
        
        var body: some View {
            VStack {
                Button("显示 Alert") {
                    showAlert = true
                }
            }
//            .sdAlert(
//                isPresented: $showAlert,
//                title: "提示",
//                message: "这是一个自定义的 Alert 视图，支持多个按钮和不同的按钮样式。",
//                buttons: [
////                    SDAlertButton(title: "取消", style: .cancel) {
////                        print("点击了取消")
////                    },
//                    SDAlertButton(title: "确定") {
//                        print("点击了确定")
//                    },
//                    SDAlertButton(title: "删除", style: .destructive) {
//                        print("点击了删除")
//                    }
//                ]
//            )
            .sdAlert(isPresented: $showAlert,
                     title: "温馨提示",
                     message: "您还不是平台的认证教师，暂时无法使用该功能。成为认证教师后，将会开放更多功能",
                     buttons: [
                        .init(title: "取消", style: .cancel, action: {}),
                            .init(title: "前往认证", style: .default, action: {})
                     ])
        }
    }
    
    return PreviewWrapper()
}
