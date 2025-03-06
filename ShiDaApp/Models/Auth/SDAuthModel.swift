//
//  SDAuthModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
import ComposableArchitecture
import CodableWrappers




/// 用户信息模型
@CustomCodable @SnakeCase
public struct UserInfo: Codable, Equatable, Identifiable, Sendable {
    /// 用户ID
    public let id: String
    
    /// 用户名
    public let username: String
    
    /// 邮箱
    public let email: String
    
    /// 头像URL
    public let avatarUrl: String?
    
    /// 创建时间
    public let createdAt: Date?
    
    /// 更新时间
    public let updatedAt: Date?
}

/// 登录响应模型
@CustomCodable @SnakeCase
public struct LoginResponse: Codable {
    /// 访问令牌
    public let accessToken: String
    
    /// 刷新令牌
    public let refreshToken: String
    
    /// 用户信息
    public let user: UserInfo
}

/// 注册响应模型
@CustomCodable @SnakeCase
public struct RegisterResponse: Codable {
    /// 用户信息
    public let user: UserInfo
}

/// 注册响应模型
@CustomCodable @SnakeCase
public struct PhoneCodeResponse: Codable {
    /// 用户信息
    public let code: String
}

/// 验证手机号
@CustomCodable @SnakeCase
public struct PhoneValidateResponse: Codable {
    /// 访问令牌
    public let token: String
    
    /// 用户信息
    public let user: UserInfo
}
