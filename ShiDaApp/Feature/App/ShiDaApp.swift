//
//  ShiDaApp.swift
//  ShiDa
//
//  Created by 黄祯鑫 on 2025/2/28.
//

import SwiftUI
@_exported import ComposableArchitecture
@_exported import SDWebImageSwiftUI


@main
struct ShiDaApp: App {
    init() {
           // 设置导航栏标题字体
           let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .regular),
               .foregroundColor: UIColor(SDColor.text1)
           ]
           appearance.largeTitleTextAttributes = [
               .font: UIFont.systemFont(ofSize: 34, weight: .regular),
               .foregroundColor: UIColor(SDColor.text1)
           ]
        // 设置返回按钮图片
        let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: nil)
        //appearance.backIndicatorImage = backImage
        //appearance.backIndicatorTransitionMaskImage = backImage
           // 应用到所有导航栏
         
           
           if #available(iOS 16.0, *) {
    // iOS 16 特定设置
    UINavigationBar.appearance().preferredBehavioralStyle = .pad
}
           
           // 移除返回按钮文字
           UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
               UIOffset(horizontal: -1000, vertical: 0), for: .default)
        
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
                // Button tinting
        let buttonAppearance = UIBarButtonItemAppearance()
        //buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
                
        // Custom back button icon
        let image = UIImage(named: "back")!.withTintColor(UIColor(SDColor.text1), renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
                
        appearance.buttonAppearance = buttonAppearance
        appearance.backButtonAppearance = buttonAppearance
        appearance.doneButtonAppearance = buttonAppearance
                
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        
        // 设置搜索栏中的 TextField 样式
        let appearanceUISearchBar = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        
        // 设置文本字体
        appearanceUISearchBar.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // 设置文本颜色
        appearanceUISearchBar.textColor = UIColor(SDColor.text1) // 改回正常文本颜色
        
        // 设置边框样式为 roundedRect
        appearanceUISearchBar.borderStyle = .roundedRect
       }
    var body: some Scene {
        WindowGroup {
            // 使用AppCoordinatorView作为程序入口
            SDAppView(
                store: Store(
                    initialState: SDAppFeature.State(),
                    reducer: { SDAppFeature() }
                )
            )
        }
    }
}
