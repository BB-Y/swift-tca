import Foundation
import ComposableArchitecture
import Moya

/// 认证相关的客户端接口
struct SDAuthClient{
    /// 登录
    var loginSMS: @Sendable  (_ para: SDReqParaLoginSMS) async throws -> SDResponseLogin
    var loginPassword: @Sendable  (_ para: SDReqParaLoginPassword) async throws -> SDResponseLogin

    /// 注册
    var register: @Sendable (_ para: SDReqParaRegister) async throws -> SDResponseLogin
    
    
    /// 登出
    var logout: @Sendable () async throws -> Bool
    
    var resetPassword: @Sendable (_ para: SDReqParaForgetPassword) async throws -> Bool

    /// 手机号身份验证
    var validatePhone: @Sendable (_ para: SDReqParaValidatePhone) async throws -> Bool
    
    var thirdpartylogin: @Sendable (_ para: SDReqParaThirdLogin) async throws -> SDResponseLogin
    var thirdpartyregist: @Sendable (_ para: SDReqParaThirdRegist) async throws -> SDResponseLogin

    
    var phoneCode: @Sendable (_ para: SDReqParaSendCode) async throws -> Bool


}

extension SDAuthClient: DependencyKey {
    /// 提供实际的认证客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            loginSMS: {
                try await apiService.requestResult(SDAuthEndpoint.loginSMS($0))
            },
            loginPassword: {
                try await apiService.requestResult(SDAuthEndpoint.loginPassword($0))
            },
            register: {
                try await apiService.requestResult(SDAuthEndpoint.register($0))
            },
            logout: {
                try await apiService.requestResult(SDAuthEndpoint.logout)
            },
            resetPassword: {
                try await apiService.requestResult(SDAuthEndpoint.resetPassword($0))
            },
            validatePhone: {
                try await apiService.requestResult(SDAuthEndpoint.validatePhone($0))
            },
            thirdpartylogin: {
                try await apiService.requestResult(SDAuthEndpoint.thirdpartylogin($0))
            },
            thirdpartyregist: {
                try await apiService.requestResult(SDAuthEndpoint.thirdpartyregist($0))
            },
            phoneCode: {
                try await apiService.requestResult(SDAuthEndpoint.sendPhoneCode($0))
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            loginSMS: { _ in
                return SDResponseLogin.mock
            },
            loginPassword: { _ in
                return SDResponseLogin.mock
            },
            register: { _ in
                return SDResponseLogin.mock
            },
            logout: {
                return true
            },
            resetPassword: { _ in
                return true
            },
            validatePhone: { _ in
                return true
            },
            thirdpartylogin: { _ in
                return SDResponseLogin.mock
            },
            thirdpartyregist: { _ in
                return SDResponseLogin.mock
            },
            phoneCode: { _ in
                return true
            }
        )
    }
    static var previewValue: SDAuthClient {
        testValue
    }
}


