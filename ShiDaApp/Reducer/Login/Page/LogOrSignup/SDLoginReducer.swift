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
    // 根据协议勾选状态返回对应图标名
    var acceptProtocolIcon: String {
        acceptProtocol ? "icon_protocol_check" : "icon_protocol_uncheck"
    }
    
    // 根据登录方式返回密码输入框占位符
    var passwordPlaceholder: String {
        isSMSLogin ? "请输入验证码" : "请输入密码"
    }
    
    // 根据 sendCodeState 返回发送验证码按钮文本
    var sendButtonText: String {
        return sendCodeState.sendButtonText
    }
    
    var title: String {
        return isSMSLogin ? "验证码登录" : "密码登录"
    }
    
    var buttonTitle: String {
        "登录"
    }
    
    var bottomTextTitle: String {
        "未注册用户会自动创建账号"
    }
    
    var bottomButtonTitle: String {
        "121212"
    }
    
    var showSendCode: Bool {
        return isSMSLogin
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
    enum Delegate {
        case loginSuccess(SDResponseLogin)
        case loginFailed(Error)
        case forgetPassword
    }

    enum Action: BindableAction {
        // 用户交互事件
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
        
        // 网络请求响应
        case loginDone(Result<SDResponseLogin, Error>)     // 登录完成
        case loginResponse(Result<SDResponseLogin, Error>) // 登录响应
        
        // 替换为 SDSendCodeReducer.Action
        case sendCode(SDSendCodeReducer.Action)
        
        // 其他 Action
        case binding(BindingAction<State>)               // 状态绑定
        
        case checkValid
        
        case delegate(Delegate)
    }
    
    // MARK: - Dependencies
    @Dependency(\.authClient) var authClient        // 认证客户端
    @Dependency(\.continuousClock) var clock       // 时钟服务
    @Dependency(\.dismiss) var dismiss            // 页面关闭
    
    // MARK: - Reducer Body
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        // 替换为 SDSendCodeReducer
        Scope(state: \.sendCodeState, action: \.sendCode) {
            SDSendCodeReducer()
        }
        
        Reduce { state, action in
            switch action {
            case let .onLinkTapped(url):
                state.showUrl = url
                return .none
                
            case .dismissWebView:
                state.showUrl = nil
                return .none
                
            case .onProtocolTapped:
                return handleProtocolTapped(state: &state)
                
            case .onToggleLoginTypeTapped:
                return handleToggleLoginType(state: &state)
                
            case .onSendCodeTapped:
                if state.sendCodeState.isCounting {
                    return .none
                }
                if let error = checkPhoneError(state.phone) {
                    return handleErrorMsg(error)
                }
                
                // 更新 sendCodeState 中的手机号并发送验证码
                state.sendCodeState.phone = state.phone
                return .send(.sendCode(.sendCode))
                
            case .onProtocolConfirmed:
                return handleProtocolConfirmed(state: &state)
                
            case .sendCode(.delegate(.sendSuccess)):
                // 验证码发送成功后，更新 defaultButtonTitle
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .sendCode(.delegate(.countDownNumber(_))):
                // 倒计时数字变化时，更新 defaultButtonTitle
                state.defaultButtonTitle = state.sendButtonText
                return .none

            case .sendCode(.delegate(.sendFailure(let errorMsg))):
                return handleErrorMsg(errorMsg)
                
            case .sendCode(.delegate(.countDownStart)):
                // 倒计时开始时的处理
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .sendCode(.delegate(.countDownFinish)):
                // 倒计时结束时的处理
                state.defaultButtonTitle = state.sendButtonText
                return .none
                
            case .sendCode(.delegate(.countDownNumber(_))):
                // 倒计时数字变化时的处理
                return .none
                
            case .eyeTapped:
                return handleEyeTapped(state: &state)
                
            case .onLoginTapped:
                return handleLoginTapped(state: &state)
                
            case let .loginResponse(.success(userInfoModel)):
                return handleLoginResponseSuccess(state: &state, userInfoModel: userInfoModel)
                
            case let .loginResponse(.failure(error)):
                return handleLoginResponseFailure(state: &state, error: error)
                
            case .onBottomButtonTapped:
                return handleBottomButtonTapped()
                
            case .onForgetTapped:
                return handleForgetTapped(state: &state)
                
            case .loginDone:
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
    
    // MARK: - Action Handlers
    
    private func handleProtocolTapped(state: inout State) -> Effect<Action> {
        state.$acceptProtocol.withLock { $0.toggle() }
        return .send(.checkValid)
    }
    
    private func handleToggleLoginType(state: inout State) -> Effect<Action> {
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
    }
    
    private func handleEyeTapped(state: inout State) -> Effect<Action> {
        state.showPassword.toggle()
        return .none
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

    
    private func checkLoginError(state: inout State) -> String? {
        if let phoneError = checkPhoneError(state.phone) {
            return phoneError
        }
                
        if let passwordError = checkPasswordError(state.password, isSMSLogin: state.isSMSLogin)  {
            return passwordError
        }
       
        return nil
    }
    
    private func handleErrorMsg(_ error: Error) -> Effect<Action> {
        if let error = error as? APIError, let msg = error.errorDescription {
            return .run { send in
                await send(.binding(.set(\.errorMsg, msg)))
                try await clock.sleep(for: .seconds(3))
                await send(.binding(.set(\.errorMsg, "")))
            }
        } else {
            return .none
        }
    }
    
    private func handleErrorMsg(_ msg: String) -> Effect<Action> {
        return .run { send in
            await send(.binding(.set(\.errorMsg, msg)))
            try await clock.sleep(for: .seconds(3))
            await send(.binding(.set(\.errorMsg, "")))
        }
    }
    
    private func handleLoginTapped(state: inout State) -> Effect<Action> {
        state.errorMsg = ""
        if let error = checkLoginError(state: &state) {
            return handleErrorMsg(error)
        }
        if !state.acceptProtocol {
            state.showProtocolSheet.toggle()
            return .none
        }

        state.isLoading = true
        let isSMSLogin = state.isSMSLogin
        let phone = state.phone
        let password = state.password
        let userType = state.userType
       
        return .run { send in
            try await self.clock.sleep(for: .seconds(2))
            if isSMSLogin {
                let para = SDReqParaLoginSMS(phone: phone, smsCode: password, userType: userType)
                await send(.loginResponse(Result { try await self.authClient.loginSMS(para) }))
            } else {
                let para = SDReqParaLoginPassword(phone: phone, password: password, userType: userType)
                await send(.loginResponse(Result { try await self.authClient.loginPassword(para) }))
            }
        }
    }
    
    private func handleLoginResponseSuccess(state: inout State, userInfoModel: SDResponseLogin) -> Effect<Action> {
        state.isLoading = false
        state.isValid = true
        state.errorMsg = ""
        
        return .send(.delegate(.loginSuccess(userInfoModel)))
    }
    
    private func handleLoginResponseFailure(state: inout State, error: Error) -> Effect<Action> {
        state.isLoading = false
        state.isValid = true
        if let apiError = error as? APIError {
            state.errorMsg = apiError.errorDescription!
            return .send(.delegate(.loginFailed(apiError)))
        }
        return .none
    }
    
    private func handleBottomButtonTapped() -> Effect<Action> {
        return .none
    }
    
    private func handleForgetTapped(state: inout State) -> Effect<Action> {
        state.errorMsg = ""
        return .send(.delegate(.forgetPassword))
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
    
    private func handleProtocolConfirmed(state: inout State) -> Effect<Action> {
        // 关闭协议弹窗
        state.showProtocolSheet = false
        // 自动勾选协议
        state.$acceptProtocol.withLock { $0 = true }
        
        // 发送验证码
        return handleLoginTapped(state: &state)
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
