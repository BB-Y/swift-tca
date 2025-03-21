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
    var getUserSettings: @Sendable () async throws -> SDResponseUserInfo
}

extension SDUserClient: DependencyKey {
    /// 提供实际的用户客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getUserSettings: {
                try await apiService.requestResult(SDUserEndpoint.getUserSettings)
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getUserSettings: {
                // 创建测试用的第三方账号列表
                let wechatAccount = SDThirdPartyAccountInfo(
                    id: 1,
                    thirdpartyAccount: "wx_test_account",
                    thirdpartyAvatarUrl: "https://example.com/avatar.jpg",
                    thirdpartyBindTime: "2025-03-15 10:00:00",
                    thirdpartyBindType: .wechat,
                    thirdpartyMailbox: "test@example.com",
                    thirdpartyNickName: "微信昵称",
                    userId: 1
                )
                
                let appleAccount = SDThirdPartyAccountInfo(
                    id: 2,
                    thirdpartyAccount: "apple_test_id",
                    thirdpartyAvatarUrl: nil,
                    thirdpartyBindTime: "2025-03-16 15:30:00",
                    thirdpartyBindType: .apple,
                    thirdpartyMailbox: "apple@example.com",
                    thirdpartyNickName: "Apple用户",
                    userId: 1
                )
                
                // 返回测试用户信息
                return SDResponseUserInfo(
                    id: 1,
                    name: "测试用户",
                    phone: "13800138000",
                    thirdparthAccountList: [wechatAccount, appleAccount],
                    userType: .teacher
                )
            }
        )
    }
    
    static var previewValue: SDUserClient {
        testValue
    }
}
