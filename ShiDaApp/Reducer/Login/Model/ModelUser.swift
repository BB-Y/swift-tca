import Foundation
import ComposableArchitecture
import CodableWrappers

//@Reducer
//public struct UserState {
//    @ObservableState
//    public struct State: Equatable {
//        public var isLoggedIn: Bool = false
//        public var userInfo: UserInfo? = nil
//        public var accessToken: String? = nil
//        public var refreshToken: String? = nil
//        
//        public init() {}
//    }
//    
//    public enum Action {
//        case setLoginState(Bool)
//        case setUserInfo(UserInfo?)
//        case setTokens(accessToken: String?, refreshToken: String?)
//        case clearUserState
//    }
//    
//    public init() {}
//    
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .setLoginState(isLoggedIn):
//                state.isLoggedIn = isLoggedIn
//                if !isLoggedIn {
//                    state.userInfo = nil
//                    state.accessToken = nil
//                    state.refreshToken = nil
//                }
//                return .none
//                
//            case let .setUserInfo(userInfo):
//                state.userInfo = userInfo
//                state.isLoggedIn = userInfo != nil
//                return .none
//                
//            case let .setTokens(accessToken, refreshToken):
//                state.accessToken = accessToken
//                state.refreshToken = refreshToken
//                return .none
//                
//            case .clearUserState:
//                state.isLoggedIn = false
//                state.userInfo = nil
//                state.accessToken = nil
//                state.refreshToken = nil
//                return .none
//            }
//        }
//    }
//}

//
//  AuthModels.swift
//  ShiDaApp
//
//  Created by AI on 2025/2/28.
//
struct UserClient {
    var setUserInfo: @Sendable (UserInfo) -> Void
    var setTokens: @Sendable (_ accessToken: String, _ refreshToken: String) -> Void
}

extension UserClient: DependencyKey {
    static var liveValue: Self {
        return Self(
            setUserInfo: { userInfo in
                // 实现设置用户信息的逻辑
                print("设置用户信息: \(userInfo)")
            },
            setTokens: { accessToken, refreshToken in
                // 实现设置令牌的逻辑
                print("设置令牌: access=\(accessToken), refresh=\(refreshToken)")
            }
        )
    }
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}

/// 登录请求模型
@CustomCodable @SnakeCase
public struct LoginRequest: Codable {
    /// 用户名
    public let username: String
    
    /// 密码
    public let password: String
}

/// 注册请求模型
@CustomCodable @SnakeCase
public struct RegisterRequest: Codable {
    /// 用户名
    public let username: String
    
    /// 密码
    public let password: String
    
    /// 确认密码
    public let confirmPassword: String
    
    /// 邮箱
    public let email: String
}

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
    public let accessToken: String
    
    /// 刷新令牌
    public let refreshToken: String
    
    /// 用户信息
    public let user: UserInfo
}
