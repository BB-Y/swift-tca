//
//  SDUserClient.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import ComposableArchitecture
import Moya

/// 用户账号相关的客户端接口
struct SDUserClient {
    /// 获取用户信息
    var getUserSettings: @Sendable () async throws -> SDResponseUserInfo
    /// 注销账号
    var deleteAccount: @Sendable () async throws -> Bool
    /// 通过旧密码重置密码
    var resetPasswordByOld: @Sendable (_ newPassword: String, _ oldPassword: String) async throws -> Bool
    /// 通过短信验证码重置密码
    var resetPasswordByCode: @Sendable (_ newPassword: String, _ smsCode: String) async throws -> Bool
    /// 获取我的消息列表
    var getMyMessages: @Sendable (_ pagination: SDPagination) async throws -> SDMessageListResult
}

extension SDUserClient: DependencyKey {
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getUserSettings: {
                try await apiService.requestResult(SDUserEndpoint.getUserSettings)
            },
            deleteAccount: {
                try await apiService.requestResult(SDUserEndpoint.deleteAccount)
            },
            resetPasswordByOld: { newPassword, oldPassword in
                let params = SDReqParaResetPasswordByOld(newPassword: newPassword, oldPassword: oldPassword)
                return try await apiService.requestResult(SDUserEndpoint.resetPasswordByOld(params: params))
            },
            resetPasswordByCode: { newPassword, smsCode in
                let params = SDReqParaResetPasswordByCode(newPassword: newPassword, smsCode: smsCode)
                return try await apiService.requestResult(SDUserEndpoint.resetPasswordByCode(params: params))
            },
            getMyMessages: { pagination in
                try await apiService.requestResult(SDUserEndpoint.getMyMessages(pagination: pagination))
            }
        )
    }
    
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
            },
            deleteAccount: {
                // 模拟注销成功
                return true
            },
            resetPasswordByOld: { _, _ in
                // 模拟重置密码成功
                return true
            },
            resetPasswordByCode: { _, _ in
                // 模拟重置密码成功
                return true
            },
            getMyMessages: { _ in
                // 模拟获取消息列表成功
                return SDMessageListResult.mock
            }
        )
    }
    
    static var previewValue: SDUserClient {
        testValue
    }
}
