import Foundation
import ComposableArchitecture
import Moya

/// 认证相关的客户端接口
struct SDAuthClient{
    /// 登录
    var login:@Sendable  (_ username: String, _ password: String) async throws -> LoginResponse
    
    /// 注册
    var register: @Sendable (_ username: String, _ password: String, _ email: String) async throws -> RegisterResponse
    
    
    var phoneCode: @Sendable (_ phoneNumber: String, _ nation: String) async throws -> RegisterResponse
    
    /// 刷新令牌
    var refreshToken:@Sendable  (_ token: String) async throws -> LoginResponse
    
    /// 登出
    var logout: @Sendable () async throws -> Void
    
    /// 手机号身份验证
    var validatePhone: @Sendable (_ phone: String, _ code: String) async throws -> PhoneValidateResponse

}

extension SDAuthClient: DependencyKey {
    /// 提供实际的认证客户端实现
    static var liveValue: Self {
        // 创建API服务
        let apiService = APIService()
        
        return Self(
            login: { username, password in
                try await apiService.requestResult(SDAuthEndpoint.login(phone: username, password: password), type: LoginResponse.self)
            },
            register: { username, password, email in
                try await apiService.requestResult(SDAuthEndpoint.register(username: username, password: password, email: email), type: RegisterResponse.self)
            },
            phoneCode: {phone, nation in
                try await apiService.requestResult(SDAuthEndpoint.logout, type: RegisterResponse.self)
            },
            refreshToken: { token in
                try await apiService.requestResult(SDAuthEndpoint.refreshToken(token), type: LoginResponse.self)
            },
            logout: {
                try await apiService.request(SDAuthEndpoint.logout)
            },
            validatePhone: {phone, code in
                try await apiService.requestResult(SDAuthEndpoint.validatePhone(phone: "", code: ""), type: PhoneValidateResponse.self)

            }1
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            login: { _, _ in
                // 返回模拟的登录响应
                return LoginResponse(
                    accessToken: "test-access-token",
                    refreshToken: "test-refresh-token",
                    user: UserInfo(
                        id: "test-id",
                        username: "testuser",
                        email: "test@example.com",
                        avatarUrl: nil,
                        createdAt: nil,
                        updatedAt: nil
                    )
                )
            },
            register: { _, _, _ in
                // 返回模拟的注册响应
                return RegisterResponse(
                    user: UserInfo(
                        id: "test-id",
                        username: "testuser",
                        email: "test@example.com",
                        avatarUrl: nil,
                        createdAt: nil,
                        updatedAt: nil
                    )
                )
            },
            phoneCode: {_, _ in
                return RegisterResponse(
                    user: UserInfo(
                        id: "test-id",
                        username: "testuser",
                        email: "test@example.com",
                        avatarUrl: nil,
                        createdAt: nil,
                        updatedAt: nil
                    )
                )
            },
            refreshToken: { _ in
                // 返回模拟的刷新令牌响应
                return LoginResponse(
                    accessToken: "new-test-access-token",
                    refreshToken: "new-test-refresh-token",
                    user: UserInfo(
                        id: "test-id",
                        username: "testuser",
                        email: "test@example.com",
                        avatarUrl: nil,
                        createdAt: nil,
                        updatedAt: nil
                    )
                )
            },
            logout: {
                // 模拟登出操作，不做任何事情
            }, validatePhone: {_,_ in
                return .init(token: "测试 token", user: .init(id: "1", username: "hzx", email: "", avatarUrl: "", createdAt: nil, updatedAt: nil))
            }
        )
        
    }
    static var previewValue: SDAuthClient {
        testValue
    }
}


