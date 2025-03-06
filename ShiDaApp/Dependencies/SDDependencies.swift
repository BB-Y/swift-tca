//
//  SDDependencies.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import Foundation
import ComposableArchitecture


//MARK - API Client
 
/// 扩展依赖值以包含认证客户端
extension DependencyValues {
    var authClient: SDAuthClient {
        get { self[SDAuthClient.self] }
        set { self[SDAuthClient.self] = newValue }
    }
}
