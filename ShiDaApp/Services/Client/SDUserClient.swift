//
//  SDUserClient.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import ComposableArchitecture
import Moya

/// 用户相关的客户端接口
struct SDUserClient {
    /// 获取用户信息
    var getUserInfo: @Sendable () async throws -> SDResponseUserInfo
}

extension SDUserClient: DependencyKey {
    /// 提供实际的用户客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getUserInfo: {
                try await apiService.requestResult(SDUserEndpoint.getUserInfo)
            }
        )
    }
    
//    /// 提供测试用的模拟实现
//    static var testValue: Self {
//        Self(
//            getUserInfo: {
//                return SDResponseUserInfo(
//                    id: 1,
//                    name: "测试用户",
//                    phone: "13800138000",
//                    thirdparthAccountList: [],
//                    userType: .student
//                )
//            }
//        )
//    }
//    
//    static var previewValue: SDUserClient {
//        testValue
//    }
}
