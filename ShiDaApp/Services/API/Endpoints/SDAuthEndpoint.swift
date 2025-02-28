import Foundation
import Moya

/// 认证相关的 API 端点
public enum SDAuthEndpoint {
    /// 登录
    case login(username: String, password: String)
    /// 注册
    case register(username: String, password: String, email: String)
    /// 刷新 token
    case refreshToken(String)
    /// 登出
    case logout
    ///验证码
    case phoneCode(_ phone: String, _ nation: String)
}

extension SDAuthEndpoint: SDEndpoint {
    public var endpointPath: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .refreshToken:
            return "/auth/refresh"
        case .logout:
            return "/auth/logout"
        case .phoneCode(_, _):
            return "/auth/code"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .register, .refreshToken, .phoneCode:
            return .post
        case .logout:
            return .delete
        }
    }
    
    public var task: Task {
        switch self {
        case let .login(username, password):
            return .requestParameters(
                parameters: [
                    "username": username,
                    "password": password
                ],
                encoding: JSONEncoding.default
            )
        case let .register(username, password, email):
            return .requestParameters(
                parameters: [
                    "username": username,
                    "password": password,
                    "email": email
                ],
                encoding: JSONEncoding.default
            )
        case let .refreshToken(token):
            return .requestParameters(
                parameters: ["refresh_token": token],
                encoding: JSONEncoding.default
            )
        case .logout:
            return .requestPlain
        case let .phoneCode(phone, nation):
            return .requestParameters(
                parameters: [
                    "phone": phone,
                    "nation": nation
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    public var requiresAuth: Bool {
        switch self {
        case .login, .register:
            return false
        case .refreshToken, .logout:
            return true
        case .phoneCode(_, _):
            return true
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
}
