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
    
    // 根据倒计时状态返回发送验证码按钮文本
    var sendButtonText: String {
        if let isCounting = countDownState.isCounting {
            if isCounting {
                return "重新发送(\(countDownState.currentNumber)s)"
            } else {
                return "重新发送"
            }
        } else {
            return "发送验证码"
        }
    }
    var title: String {
        return isSMSLogin ? "验证码登录" : "密码登录"
        
        //            if isLogin {
        //                return isSMSLogin ? "验证码登录" : "密码登录"
        //            } else {
        //                if let userType {
        //                    switch userType {
        //                    case .student:
        //                        return "学生注册"
        //                    case .teacher:
        //                        return "教师注册"
        //                    }
        //                } else {
        //                    return "注册"
        //                }
        //            }
        
    }
    var buttonTitle: String {
        "登录"
        //isLogin ? "登录" : "注册"
    }
    var bottomTextTitle: String {
        "未注册用户会自动创建账号"
        // isLogin ? "还没有账号？" : "已有账号"
    }
    var bottomButtonTitle: String {
        "121212"
        //isLogin ? "去注册" : "去登录"
    }
    var showSendCode: Bool {
        return isSMSLogin
        
        //            if isLogin {
        //                return isSMSLogin
        //            } else {
        //                return true
        //            }
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
        
        // 协议相关
        var showProtocolSheet: Bool = false // 协议弹窗显示状态
        var showUrl: String? = nil         // 协议 URL
        
        // 验证码倒计时状态
        var countDownState = SDCountDownReducer.State(startNumber: 5)
        
        // 共享状态
        @Shared(.shareUserToken) var token = ""
        @Shared(.shareUserInfo) var userInfo = nil
        
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
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
        case codeResponse(Result<Bool, Error>)            // 验证码响应
        
        // 其他 Action
        case countDownAction(SDCountDownReducer.Action)   // 倒计时相关
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
        Scope(state: \.countDownState, action: \.countDownAction) {
            SDCountDownReducer()
        }
        // 在 Reducer 中处理新增的 Action
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
                return handleSendCodeTapped(state: &state)
            case .onProtocolConfirmed:
                return handleProtocolConfirmed(state: &state)
            case let .codeResponse(.success(isSended)):
                return handleCodeResponseSuccess(isSended: isSended)
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
            case .binding(\.isFlipping):
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
    
    private func handleSendCodeTapped(state: inout State) -> Effect<Action> {
        if state.countDownState.isCounting == true {
            return .none
        }
        if let error = checkPhoneError(state.phone) {
            state.errorMsg = error
            return .none
        }
        

        // 协议已勾选，直接发送验证码
        return sendVerificationCode(phone: state.phone)
    }
    
    // 新增一个辅助方法用于发送验证码
    private func sendVerificationCode(phone: String) -> Effect<Action> {
        let para = SDReqParaSendCode(isForget: false, isRegister: false, phoneNum: phone, type: .app)
        return .run { send in
            await send(.countDownAction(.start))
            await send(.codeResponse(Result { try await self.authClient.phoneCode(para) }))
        }
    }
    
    private func handleCodeResponseSuccess(isSended: Bool) -> Effect<Action> {
        if isSended {
            return .send(.countDownAction(.start))
        }
        return .none
    }
    
    private func handleEyeTapped(state: inout State) -> Effect<Action> {
        state.showPassword.toggle()
        return .none
    }
    
    private func checkPhoneError(_ phone: String) -> String? {
        if phone.isEmpty {
            print("手机号不能为空")
            return "手机号不能为空"
        }
        if !phone.isValidPhoneNumber {
            print("手机号格式错误")
            return "手机号格式错误"
        }
        return nil
    }
    private func checkPasswordError(_ password: String, isSMSLogin: Bool) -> String? {
        
        if isSMSLogin {
            if password.isEmpty {
                return "验证码不能为空"
                
            }
            if !password.isValidSixNumber {
                return "验证码格式错误"
                
            }
        } else {
            if password.isEmpty {
                return "密码不能为空"
            }
            if !password.isValidPassword {
                return "密码格式错误"
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
        //state.isLogin.toggle()
        return .none
    }
    
    private func handleForgetTapped(state: inout State) -> Effect<Action> {
        state.errorMsg = ""
        return .send(.delegate(.forgetPassword))
    }
    
    
    
    private func handlePhoneOrPasswordBinding(state: inout State) -> Effect<Action> {
        
        
        print(state.phone)
        print(state.password)

        guard checkPhoneError(state.phone) == nil else {
            state.isValid = false
            print("checkPhoneError")

            return .none
        }
        print("checkPhoneNoError")

        guard checkPasswordError(state.password, isSMSLogin: state.isSMSLogin) == nil else {
            print("checkPasswordError")

            state.isValid = false
            return .none
        }
        print("checkPasswordNoError")

        guard state.acceptProtocol else {
            print("acceptProtocolError")

            state.isValid = false
            return .none
        }
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
        //return sendVerificationCode(phone: state.phone)
    }
}



