import Foundation

import Moya

/// 认证相关的 API 端点
public enum SDAuthEndpoint {
    /// 登录
    case login(phone: String, password: String)
    /// 注册
    case register(username: String, password: String, email: String)
    /// 刷新 token
    case refreshToken(String)
    /// 登出
    case logout
    ///验证码
    case phoneCode(_ phone: String, _ nation: String)
    
    ///重置密码
    case resetPassword(String)
    
    ///更改密码
    case changePassword(String, String)
    
    /// 验证手机号
    case validatePhone(phone: String, code: String)

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
        case .resetPassword(_):
            return "/auth/code"

        case .changePassword(_, _):
            return "/auth/code"

        case .validatePhone(_):
            return "/auth/phoe"

        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .register, .refreshToken, .phoneCode, .resetPassword, .changePassword, .validatePhone:
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
        case .resetPassword(_):
            return .requestPlain
        case .changePassword(_, _):
            return .requestPlain

        case .validatePhone(phone: let phone, code: let code):
            return .requestPlain

        }
    }
   
    
    public var sampleData: Data {
        return Data()
    }
}
