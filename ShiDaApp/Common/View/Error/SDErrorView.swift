//
//  SDErrorView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import SwiftUI

/// 错误视图样式枚举
public enum SDErrorStyle {
    case networkError  // 网络连接失败
    case emptyData     // 暂无数据
    // 可在此处扩展更多错误类型
}

/// 错误视图配置模型
public struct SDErrorConfig {
    let title: String
    let message: String
    let style: SDErrorStyle
    let buttonTitle: String?
    let image: Image?
    let action: (() -> Void)?
    let backgroundColor: Color?  // 新增背景色属性
    
    public init(
        title: String,
        message: String,
        style: SDErrorStyle,
        buttonTitle: String? = nil,
        image: Image? = nil,
        action: (() -> Void)? = nil,
        backgroundColor: Color? = nil  // 新增背景色参数
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.buttonTitle = buttonTitle
        self.image = image
        self.action = action
        self.backgroundColor = backgroundColor
    }
    
    // 预设配置 - 网络错误
    public static func networkError(
        title: String = "网络连接失败",
        message: String = "点击屏幕或下拉刷新重试",
        buttonTitle: String? = "重试",
        action: (() -> Void)? = nil,
        backgroundColor: Color? = nil  // 新增背景色参数
    ) -> SDErrorConfig {
        SDErrorConfig(
            title: title,
            message: message,
            style: .networkError,
            buttonTitle: buttonTitle,
            image: Image("error_net"),
            action: action,
            backgroundColor: backgroundColor
        )
    }
    
    // 预设配置 - 暂无数据
    public static func emptyData(
        title: String = "暂无数据",
        message: String = "",
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil,
        backgroundColor: Color? = nil  // 新增背景色参数
    ) -> SDErrorConfig {
        SDErrorConfig(
            title: title,
            message: message,
            style: .emptyData,
            buttonTitle: buttonTitle,
            image: Image("error_null"),
            action: action,
            backgroundColor: backgroundColor
        )
    }
}

struct SDErrorView: View {
    let config: SDErrorConfig
    
    var body: some View {
        VStack(spacing: 16) {
            // 错误图标
            if let image = config.image {
                image
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                    .foregroundColor(.gray)
            } else {
                // 根据错误类型显示默认图标
                switch config.style {
                case .networkError:
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                case .emptyData:
                    Image(systemName: "tray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }
            }
            
            // 错误标题
            Text(config.title)
                .font(.system(size: 13))
                .foregroundColor(SDColor.text3)
            
            // 错误信息
            if !config.message.isEmpty {
                Text(config.message)
                    .font(.system(size: 13))
                    .foregroundColor(SDColor.text3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // 操作按钮
//            if let buttonTitle = config.buttonTitle {
//                Button(action: {
//                    config.action?()
//                }) {
//                    Text(buttonTitle)
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 24)
//                        .padding(.vertical, 10)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding(.top, 8)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(config.backgroundColor ?? Color.clear)  // 使用配置的背景色或默认透明
        .onTapGesture {
            config.action?()
        }
    }
}

// 扩展 View 以便于使用
public extension View {
    func sdErrorOverlay<T: View>(
        isPresented: Binding<Bool>,
        config: SDErrorConfig,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                content()
                    .transition(.opacity)
            }
        }
    }
    
    // 便捷方法 - 显示网络错误
    func sdNetworkErrorOverlay(
        isPresented: Binding<Bool>,
        backgroundColor: Color? = nil,
        action: (() -> Void)? = nil// 新增背景色参数
    ) -> some View {
        self.sdErrorOverlay(
            isPresented: isPresented,
            config: .networkError(action: action, backgroundColor: backgroundColor)
        ) {
            SDErrorView(config: .networkError(action: action, backgroundColor: backgroundColor))
        }
    }
    
    // 便捷方法 - 显示暂无数据
    func sdEmptyDataOverlay(
        isPresented: Binding<Bool>,
        message: String = "",
        backgroundColor: Color? = nil,
        action: (() -> Void)? = nil
    ) -> some View {
        self.sdErrorOverlay(
            isPresented: isPresented,
            config: .emptyData(message: message, action: action, backgroundColor: backgroundColor)
        ) {
            SDErrorView(config: .emptyData(message: message, action: action, backgroundColor: backgroundColor))
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showNetworkError = false
        @State private var showEmptyData = false
        
        var body: some View {
            VStack(spacing: 20) {
                Button("显示网络错误") {
                    showNetworkError = true
                    showEmptyData = false
                }
                
                Button("显示暂无数据") {
                    showEmptyData = true
                    showNetworkError = false
                }
                
                Button("隐藏错误") {
                    showNetworkError = false
                    showEmptyData = false
                }
            }
           
            .sdNetworkErrorOverlay(isPresented: $showNetworkError, backgroundColor: SDColor.background.opacity(1)) {
                showNetworkError.toggle()
            }
            .sdEmptyDataOverlay(isPresented: $showEmptyData)
            
        }
    }
    
    return PreviewWrapper()
}
