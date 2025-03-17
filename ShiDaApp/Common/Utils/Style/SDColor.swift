//
//  SDColor.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI

/// 师大App颜色管理
public enum SDColor {
    // MARK: - 品牌颜色
    
    /// 主题色 - 粉色
    public static var primary: Color { Color("Primary", bundle: .main) }
    
    /// 次要主题色 - 浅粉色
    public static var secondary: Color { Color("Secondary", bundle: .main) }
    
    /// 强调色 - 用于重点突出
    public static var accent: Color { Color("Accent", bundle: .main) }
    
    
    public static var blue: Color { Color("Blue", bundle: .main) }
    public static var blueBack: Color { Color("Blue", bundle: .main).opacity(0.16) }

    
    
    // MARK: - 功能颜色
    
    /// 成功状态
    public static var success: Color { Color("Success", bundle: .main) }
    
    /// 警告状态
    public static var warning: Color { Color("Warning", bundle: .main) }
    
    /// 错误状态
    public static var error: Color { Color("Error", bundle: .main) }
    
    /// 信息提示
    public static var info: Color { Color("Info", bundle: .main) }
    
    /// 随机色
    public static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
    
    // MARK: - 中性色
    
    /// 背景色 - 主要
    public static var background: Color { Color("Background", bundle: .main) }
    
    /// 背景色 - 次要
    public static var backgroundSecondary: Color { Color("BackgroundSecondary", bundle: .main) }
    
    /// 文本 - 主要#23252B
    public static var text1: Color { Color("Text1", bundle: .main) }
    
    /// 文本 - 次要#737278
    public static var text2: Color { Color("Text2", bundle: .main) }
    
    /// 文本 - 次要#94959A
    public static var text3: Color { Color("Text3", bundle: .main) }
    
    /// 文本 - 禁用
    public static var textDisabled: Color { Color("TextDisabled", bundle: .main) }
    
    /// 分割线 #E7E7E7
    public static var divider: Color { Color("Divider", bundle: .main) }
    
    /// 分割线 #F5F5F5
    public static var divider1: Color { Color(hex: "#F5F5F5") }
    /// 边框
    public static var border: Color { Color("Border", bundle: .main) }
    
    
    /// background: #ECEDF1;
    public static var buttonBackGray: Color { Color("ButtonBackGray", bundle: .main) }
    
    /// 验证码输入背景色 #F4F5F7
    public static var inputBackground: Color { Color(hex: "#F4F5F7") }

    // MARK: - 扩展颜色
    
    /// 标签背景 - 首页
    public static var homeTab: Color { Color("HomeTab", bundle: .main) }
    
    /// 标签背景 - 书籍
    public static var bookTab: Color { Color("BookTab", bundle: .main) }
    
    /// 标签背景 - 学习
    public static var studyTab: Color { Color("StudyTab", bundle: .main) }
    
    /// 标签背景 - 我的
    public static var myTab: Color { Color("MyTab", bundle: .main) }
}

// MARK: - SwiftUI Color 扩展
extension Color {
    /// 使用十六进制字符串创建颜色
    /// - Parameters:
    ///   - hex: 十六进制颜色字符串，例如 "#FF0000"
    ///   - opacity: 不透明度，默认为1.0
    public init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - UIKit 兼容扩展
#if canImport(UIKit)
import UIKit

extension SDColor {
    /// 获取UIKit颜色
    /// - Parameter color: SwiftUI颜色
    /// - Returns: UIKit颜色
//    public static func uiColor(_ color: KeyPath<SDColor, Color>) -> UIColor {
//        UIColor(self[keyPath: color])
//    }
}

extension UIColor {
    /// 使用十六进制字符串创建颜色
    /// - Parameters:
    ///   - hex: 十六进制颜色字符串，例如 "#FF0000"
    ///   - alpha: 不透明度，默认为1.0
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#endif
