//
//  SDToastView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import SwiftUI
import PopupView

/// Toast样式枚举
public enum SDToastStyle {
    case loading
    case text
    case imageWithText
}

/// Toast配置模型
public struct SDToastConfig {
    let message: String
    let style: SDToastStyle
    let image: Image?
    let duration: Double
    
    public init(
        message: String,
        style: SDToastStyle = .text,
        image: Image? = nil,
        duration: Double = 2.0
    ) {
        self.message = message
        self.style = style
        self.image = image
        self.duration = duration
    }
}

struct SDToastView: View {
    let config: SDToastConfig
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            switch config.style {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2)
            
                    .tint(Color.white)
                if !config.message.isEmpty {
                    Text(config.message)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                
            case .text:
                Text(config.message)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
            case .imageWithText:
                if let image = config.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
                
                Text(config.message)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            if config.style != .loading {
                DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                    isPresented = false
                }
            }
        }
    }
}

// 用于在 SwiftUI 中显示 Toast 的修饰器
public struct SDToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let config: SDToastConfig
    
    public func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented) {
                SDToastView(
                    config: config,
                    isPresented: $isPresented
                )
            } customize: {
                $0
                    .type(.toast)
                    .position(.center)
                    .animation(.easeInOut(duration: 0.2))
                    .appearFrom(.centerScale)

                    .autohideIn(config.style == .loading ? .infinity : config.duration)
                    .closeOnTapOutside(false)
                    .backgroundColor(Color.clear)
            }
    }
}

// 扩展 View 以便于使用
public extension View {
    func sdToast(
        isPresented: Binding<Bool>,
        config: SDToastConfig
    ) -> some View {
        self.modifier(SDToastModifier(
            isPresented: isPresented,
            config: config
        ))
    }
    
    // 便捷方法 - 显示加载中
    func sdLoadingToast(
        isPresented: Binding<Bool>,
        message: String = "加载中"
    ) -> some View {
        self.sdToast(
            isPresented: isPresented,
            config: SDToastConfig(
                message: message,
                style: .loading
            )
        )
    }
    
    // 便捷方法 - 显示纯文本
    func sdTextToast(
        isPresented: Binding<Bool>,
        message: String,
        duration: Double = 2.0
    ) -> some View {
        self.sdToast(
            isPresented: isPresented,
            config: SDToastConfig(
                message: message,
                style: .text,
                duration: duration
            )
        )
    }
    
    // 便捷方法 - 显示图文混合
    func sdImageTextToast(
        isPresented: Binding<Bool>,
        message: String,
        image: Image,
        duration: Double = 2.0
    ) -> some View {
        self.sdToast(
            isPresented: isPresented,
            config: SDToastConfig(
                message: message,
                style: .imageWithText,
                image: image,
                duration: duration
            )
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showLoadingToast = false
        @State private var showTextToast = false
        @State private var showImageTextToast = false
        
        var body: some View {
            VStack(spacing: 20) {
                Button("显示加载中Toast") {
                    showLoadingToast = true
                }
                
                Button("显示纯文本Toast") {
                    showTextToast = true
                }
                
                Button("显示图文混合Toast") {
                    showImageTextToast = true
                }
            }
            .sdLoadingToast(isPresented: $showLoadingToast)
            .sdTextToast(isPresented: $showTextToast, message: "操作成功")
            .sdImageTextToast(
                isPresented: $showImageTextToast,
                message: "保存成功",
                image: Image(systemName: "checkmark.circle.fill")
            )
        }
    }
    
    return PreviewWrapper()
}
