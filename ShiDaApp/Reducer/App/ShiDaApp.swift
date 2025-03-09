//
//  ShiDaApp.swift
//  ShiDa
//
//  Created by 黄祯鑫 on 2025/2/28.
//

import SwiftUI
@_exported import ComposableArchitecture

@main
struct ShiDaApp: App {
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
