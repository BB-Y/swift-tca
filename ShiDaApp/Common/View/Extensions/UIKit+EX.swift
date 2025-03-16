//
//  UIKit+EX.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/16.
//

import Foundation

// 在文件顶部添加
import UIKit

// 在 SDBookDetailView 外部添加这个扩展
extension UIApplication {
    static var safeAreaTop: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    static var safeAreaBottom: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
    
    // 获取状态栏高度
    static var statusBarHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    // 获取导航栏高度
    static var navigationBarHeight: CGFloat {
        return 44.0 // 标准导航栏高度
    }
    
    // 获取状态栏+导航栏的总高度
    static var statusBarAndNavigationBarHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
}
