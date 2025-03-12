//
//  SDLoginReducer.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
import ComposableArchitecture

// MARK: - State 计算属性扩展
extension SDLoginReducer.State {
   
    
    // 根据 sendCodeState 返回发送验证码按钮文本
    var sendButtonText: String {
        return sendCodeState.sendButtonText
    }
    
  
  
    
    var userInfoModel: SDResponseLogin? {
        guard let data = userInfo else { return nil }
        return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
    }
    
    var userType:SDUserType? {
        userInfoModel?.userType
    }
}

@Reducer
struct SDLoginReducer {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        // 用户输入信息
        var phone: String = ""
        var nationCode: String = "86"
        var password: String = ""
        
        // UI 状态
        var isSMSLogin: Bool = true // 是否为短信验证码登录
        var isLoading: Bool = false // 加载状态
        var isValid: Bool = false   // 登录按钮是否可用
        var errorMsg: String = ""   // 错误信息
        var showPassword = false    // 是否显示密码
        var isFlipping = false      // 切换登录方式的翻转动画
        
        // 保留这个属性，用于初始显示
        var defaultButtonTitle = "发送验证码"
        
        // 协议相关
        var showProtocolSheet: Bool = false // 协议弹窗显示状态
        var showUrl: String? = nil         // 协议 URL
        
        // 替换为 SDSendCodeReducer.State
        var sendCodeState: SDSendCodeReducer.State
        
        // 共享状态
        @Shared(.shareUserToken) var token = ""
        @Shared(.shareUserInfo) var userInfo = nil
        
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        
        init() {
            self.sendCodeState = SDSendCodeReducer.State(phone: "", sendCodeType: .verify)
        }
    }
    
    // MARK: - Actions
    enum Action: BindableAction, ViewAction {
        // 业务逻辑相关的 Action
        case loginWithSMS(phone: String, code: String, userType: SDUserType?)
        case loginWithPassword(phone: String, password: String, userType: SDUserType?)
        case loginResponse(Result<SDResponseLogin, Error>)
        case sendCode(SDSendCodeReducer.Action)
        case checkValid
        case delegate(Delegate)
        
        // 视图相关的 Action
        case view(ViewAction)
        
        // 绑定 Action
        case binding(BindingAction<State>)
        
        // 视图 Action 枚举
        enum ViewAction {
            case onLoginTapped           // 点击登录按钮
            case onBottomButtonTapped    // 点击底部按钮
            case onForgetTapped         // 点击忘记密码
            case onSendCodeTapped       // 点击发送验证码
            case onProtocolTapped       // 点击协议勾选框
            case onLinkTapped(String)   // 点击协议链接
            case eyeTapped             // 点击密码显示切换
            case onToggleLoginTypeTapped // 切换登录方式
            case onProtocolConfirmed    // 确认协议
            case dismissWebView         // 关闭协议网页
            case showErrorMessage(String, duration: TimeInterval = 3)  // 显示错误信息
        }
        
        enum Delegate {
            case loginSuccess(SDResponseLogin)
            case loginFailed(Error)
            case forgetPassword
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.authClient) var authClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dismiss) var dismiss
    
    // MARK: - Reducer Body
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.sendCodeState, action: \.sendCode) {
            SDSendCodeReducer()
        }
        
        Reduce { state, action in
            switch action {
            // 处理视图 Action
            case let .view(viewAction):
                return handleViewAction(state: &state, viewAction: viewAction)
                
            // 处理业务逻辑 Action
            case let .loginWithSMS(phone, code, userType):
                state.isLoading = true
                return .run { send in
                    let para = SDReqParaLoginSMS(phone: phone, smsCode: code, userType: userType)
                    await send(.loginResponse(Result { try await self.authClient.loginSMS(para) }))
                }
                
            case let .loginWithPassword(phone, password, userType):
                state.isLoading = true
                return .run { send in
                    let para = SDReqParaLoginPassword(phone: phone, password: password, userType: userType)
                    await send(.loginResponse(Result { try await self.authClient.loginPassword(para) }))
                }
                
            case let .loginResponse(.success(userInfoModel)):
                state.isLoading = false
                state.isValid = true
                state.errorMsg = ""
                return .send(.delegate(.loginSuccess(userInfoModel)))
                
            case let .loginResponse(.failure(error)):
                state.isLoading = false
                state.isValid = true
                if let apiError = error as? APIError {
                    state.errorMsg = apiError.errorDescription!
                    return .send(.delegate(.loginFailed(apiError)))
                }
                return .none
                
            case .sendCode(.delegate(.sendSuccess)):
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .sendCode(.delegate(.countDownNumber(_))):
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .sendCode(.delegate(.sendFailure(let errorMsg))):
                return .send(.view(.showErrorMessage(errorMsg)))
                
            case .sendCode(.delegate(.countDownStart)), .sendCode(.delegate(.countDownFinish)):
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .binding(\.phone), .binding(\.password), .binding(\.$acceptProtocol):
                return handlePhoneOrPasswordBinding(state: &state)
                
            case .binding:
                return .none
                
            case .checkValid:
                return handlePhoneOrPasswordBinding(state: &state)
                
            default:
                return .none
            }
        }
    }
    
    // MARK: - View Action Handler
    private func handleViewAction(state: inout State, viewAction: Action.ViewAction) -> Effect<Action> {
        switch viewAction {
        case let .onLinkTapped(url):
            state.showUrl = url
            return .none
            
        case .dismissWebView:
            state.showUrl = nil
            return .none
            
        case .onProtocolTapped:
            state.$acceptProtocol.withLock { $0.toggle() }
            return .send(.checkValid)
            
        case .onToggleLoginTypeTapped:
            let isSMSLogin = state.isSMSLogin
            
            return .run { send in
                await send(.binding(.set(\.isFlipping, true)))
                try await clock.sleep(for: .seconds(0.3))
                await send(.binding(.set(\.isSMSLogin, !isSMSLogin)))
                
                // 重置相关状态
                await send(.binding(.set(\.password, "")))
                await send(.binding(.set(\.errorMsg, "")))
                await send(.binding(.set(\.isValid, false)))
                
                try await clock.sleep(for: .seconds(0.3))
                await send(.binding(.set(\.isFlipping, false)))
            }
            
        case .onSendCodeTapped:
            if state.sendCodeState.isCounting {
                return .none
            }
            if let error = checkPhoneError(state.phone) {
                return .send(.view(.showErrorMessage(error)))
            }
            
            // 更新 sendCodeState 中的手机号并发送验证码
            state.sendCodeState.phone = state.phone
            return .send(.sendCode(.sendCode))
            
        case .onProtocolConfirmed:
            // 关闭协议弹窗
            state.showProtocolSheet = false
            // 自动勾选协议
            state.$acceptProtocol.withLock { $0 = true }
            
            // 发送登录请求
            return handleLoginRequest(state: &state)
            
        case .eyeTapped:
            state.showPassword.toggle()
            return .none
            
        case .onLoginTapped:
            state.errorMsg = ""
            if let error = checkLoginError(state: &state) {
                return .send(.view(.showErrorMessage(error)))
            }
            if !state.acceptProtocol {
                state.showProtocolSheet.toggle()
                return .none
            }

            return handleLoginRequest(state: &state)
            
        case .onBottomButtonTapped:
            return .none
            
        case .onForgetTapped:
            state.errorMsg = ""
            return .send(.delegate(.forgetPassword))
            
        case let .showErrorMessage(message, duration):
            return .run { send in
                await send(.binding(.set(\.errorMsg, message)))
                try await clock.sleep(for: .seconds(duration))
                await send(.binding(.set(\.errorMsg, "")))
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleLoginRequest(state: inout State) -> Effect<Action> {
        let isSMSLogin = state.isSMSLogin
        let phone = state.phone
        let password = state.password
        let userType = state.userType
        
        if isSMSLogin {
            return .send(.loginWithSMS(phone: phone, code: password, userType: userType))
        } else {
            return .send(.loginWithPassword(phone: phone, password: password, userType: userType))
        }
    }
    
    private func checkPhoneError(_ phone: String) -> String? {
        if phone.isEmpty {
            return LoginError.phoneEmpty.errorDescription
        }
        if !phone.isValidPhoneNumber {
            return LoginError.phoneInvalid.errorDescription
        }
        return nil
    }
    
    private func checkPasswordError(_ password: String, isSMSLogin: Bool) -> String? {
        if isSMSLogin {
            if password.isEmpty {
                return LoginError.codeEmpty.errorDescription
            }
            if !password.isValidSixNumber {
                return LoginError.codeInvalid.errorDescription
            }
        } else {
            if password.isEmpty {
                return LoginError.passwordEmpty.errorDescription
            }
            if !password.isValidPassword {
                return LoginError.passwordInvalid.errorDescription
            }
        }
        return nil
    }
    
    // 补充丢失的函数
    private func checkLoginError(state: inout State) -> String? {
        if let phoneError = checkPhoneError(state.phone) {
            return phoneError
        }
                
        if let passwordError = checkPasswordError(state.password, isSMSLogin: state.isSMSLogin)  {
            return passwordError
        }
       
        return nil
    }
    
    private func handlePhoneOrPasswordBinding(state: inout State) -> Effect<Action> {
        // 检查手机号
        if checkPhoneError(state.phone) != nil {
            state.isValid = false
            return .none
        }
        
        // 检查密码/验证码
        if checkPasswordError(state.password, isSMSLogin: state.isSMSLogin) != nil {
            state.isValid = false
            return .none
        }
        
        // 检查协议
        if !state.acceptProtocol {
            state.isValid = false
            return .none
        }
        
        // 所有验证通过
        state.isValid = true
        state.errorMsg = ""
        return .none
    }
}

// MARK: - Login Error
enum LoginError: LocalizedError {
    case phoneEmpty
    case phoneInvalid
    case passwordEmpty
    case passwordInvalid
    case codeEmpty
    case codeInvalid
    
    var errorDescription: String? {
        switch self {
        case .phoneEmpty: return "手机号不能为空"
        case .phoneInvalid: return "手机号格式错误"
        case .passwordEmpty: return "密码不能为空"
        case .passwordInvalid: return "密码格式错误"
        case .codeEmpty: return "验证码不能为空"
        case .codeInvalid: return "验证码格式错误"
        }
    }
}
