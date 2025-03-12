import Foundation

import Moya

/// 认证相关的 API 端点 如果token过期了，接口错误码是401
enum SDAuthEndpoint {
    /// 登录
    case loginSMS(_ model: SDReqParaLoginSMS)
    
    /// 登录
    case loginPassword(_ model: SDReqParaLoginPassword)
    /// 注册
    case register(_ model: SDReqParaRegister)
   
    /// 登出不清空 token
    case logout
   
    
    ///重置密码
    case resetPassword(SDReqParaForgetPassword)
    

    
    /// 验证手机号 resturn Bool
    case validatePhone(SDReqParaValidatePhone)

    /// 三方登录
    case thirdpartylogin(_ model: SDReqParaThirdLogin)
    
    /// 三方登录后未注册需要注册
    case thirdpartyregist(_ model: SDReqParaThirdRegist)

    ///验证码
    case sendPhoneCode(SDReqParaSendCode)
}

extension SDAuthEndpoint: SDEndpoint {
    
    public var path: String {
        switch self {
        case .loginSMS:         return "/app/portal/smslogin"
        case .loginPassword:    return "/app/portal/passwordlogin"
        case .register:         return "/app/portal/regist"
        case .logout:           return "/app/portal/quit"
        case .resetPassword:    return "/app/portal/forgetpwd"
        case .validatePhone:    return "/app/portal/check"
        case .thirdpartylogin:  return "/app/portal/thirdpartylogin"
        case .thirdpartyregist: return "/app/portal/thirdpartyregist"
        case .sendPhoneCode:    return "/app/sms" // 更新路径
        }
    }
    
    public var method: Moya.Method {
        switch self {
            
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case let .loginSMS(model):
            return .requestJSONEncodable(model)
            
        case let .loginPassword(model):
            return .requestJSONEncodable(model)
            
        case let .register(model):
            return .requestJSONEncodable(model)

        case .logout:
            return .requestPlain
       
        case let .resetPassword(model):
            return .requestJSONEncodable(model)
        
        case let .validatePhone(model):
            return .requestJSONEncodable(model)

        case let .thirdpartylogin(model):
            return .requestJSONEncodable(model)

        case let .thirdpartyregist(model):
            return .requestJSONEncodable(model)
            
        case let .sendPhoneCode(model):
            return .requestJSONEncodable(model)
        }
    }
}
