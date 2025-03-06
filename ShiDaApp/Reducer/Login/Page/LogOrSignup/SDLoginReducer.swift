//
//  SDLoginReducer.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
import ComposableArchitecture

extension SDLoginReducer.State {
    var acceptProtocolIcon: String {
        acceptProtocol ? "icon_protocol_check" : "icon_protocol_uncheck"
    }
    var passwordPlaceholder: String {
        isSMSLogin ? "请输入验证码" : "请输入密码"
    }
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
    
    
}
@Reducer
struct SDLoginReducer {
    
    // 在 State 结构体中添加 showUrl 状态
    @ObservableState
    struct State: Equatable {
        
        //var isLogin: Bool
        var phone: String = ""
        var nationCode: String = "86"
        
        var password: String = ""
        var isSMSLogin: Bool = true //手机号登录或密码登录
        var isLoading: Bool = false
        var isValid: Bool = false //登录按钮是否可用
        var errorMsg: String = ""
        var showPassword = false
        
        // 添加协议弹窗显示状态
        var showProtocolSheet: Bool = false
        var showUrl: String? = nil  // 添加这一行
        
        var countDownState = SDCountDownReducer.State(startNumber: 5)
        
        var isFlipping = false //翻转动画
        
        @Shared(.shareUserToken) var token = ""
        @Shared(.shareUserInfo) var userInfo = nil
        @Shared(.shareUserType) var userType = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        
        
    }
    
    enum Action: BindableAction {
        case onLoginTapped
        case onBottomButtonTapped
        case onForgetTapped
        case onSendCodeTapped
        case onProtocolTapped
        case onLinkTapped(String)  // 添加这一行
        case dismissWebView        // 添加这一行
        case showHome
        case loginResponse(Result<SDResponseLogin, Error>)
        case codeResponse(Result<Bool, Error>)
        case onProtocolConfirmed // 新增：用户在弹窗中点击"同意并继续"
        
        case eyeTapped
        case onToggleLoginTypeTapped
        case countDownAction(SDCountDownReducer.Action)
        
        case binding(BindingAction<State>)
    }
    @Dependency(\.authClient) var authClient
    
    @Dependency(\.continuousClock) var clock
    
    @Dependency(\.dismiss) var dismiss
    
    
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
            case .showHome:
                return handleShowHome(state: &state)
            case .binding(\.isFlipping):
                return .none
            case .binding(\.phone), .binding(\.password):
                return handlePhoneOrPasswordBinding(state: &state)
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleProtocolTapped(state: inout State) -> Effect<Action> {
        state.$acceptProtocol.withLock { $0.toggle() }
        return .none
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
        if state.phone.isEmpty {
            state.errorMsg = "手机号不能为空"
            
            return .run { send in
                try await clock.sleep(for: .seconds(3))
                await send(.binding(.set(\.errorMsg, "")))
            }
        }
        if !state.phone.isValidPhoneNumber {
            state.errorMsg = "手机号格式错误"
            return .none
        }
        
        // 检查协议是否勾选
        if !state.acceptProtocol {
            // 如果未勾选，显示协议弹窗
            state.showProtocolSheet = true
            return .none
        }
        
        // 协议已勾选，直接发送验证码
        return sendVerificationCode(phone: state.phone)
    }
    
    // 新增一个辅助方法用于发送验证码
    private func sendVerificationCode(phone: String) -> Effect<Action> {
        let para = SDReqParaSendCode(isForget: false, isRegister: false, phoneNum: phone, type: .app)
        return .run { send in
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
    
    private func handleLoginTapped(state: inout State) -> Effect<Action> {
        state.errorMsg = ""
        
        if state.phone.isEmpty {
            state.errorMsg = "手机号不能为空"
            return.none
        }
        if !state.phone.isValidPhoneNumber {
            state.errorMsg = "手机号格式错误"
            return.none
        } 
        if state.isSMSLogin {
            if !state.password.isValidSixNumber {
                state.errorMsg = "验证码格式错误"
                return.none
            }
        } else {
            if !state.password.isValidPassword {
                state.errorMsg = "密码格式错误"
                return.none
            }
        }
        
        if state.password.isEmpty {
            state.errorMsg = "密码不能为空"
            return.none
        }
        state.isLoading = true
        let phone = state.phone
        let password = state.password
        let para = SDReqParaLoginSMS(phone: phone, smsCode: password, userType: .student)
        return .run { send in
            await send(.loginResponse(Result { try await self.authClient.loginSMS(para) }))
        }
    }
    
    private func handleLoginResponseSuccess(state: inout State, userInfoModel: SDResponseLogin) -> Effect<Action> {
        print("loginResponse")
        state.isLoading = false
        state.isValid = true
        // 更新全局用户状态
        let data = Data.getData(from: userInfoModel)
        state.$userInfo.withLock({$0 = data})
        
        state.$token.withLock({$0 = "token get"})
        return .run { send in
            await send(.showHome)
        }
    }
    
    private func handleLoginResponseFailure(state: inout State, error: Error) -> Effect<Action> {
        state.isLoading = false
        state.isValid = false
        state.errorMsg = error.localizedDescription
        return .none
    }
    
    private func handleBottomButtonTapped() -> Effect<Action> {
        //state.isLogin.toggle()
        return .none
    }
    
    private func handleForgetTapped(state: inout State) -> Effect<Action> {
        state.errorMsg = ""
        return .none
    }
    
    private func handleShowHome(state: inout State) -> Effect<Action> {
        state.isValid = true
        state.errorMsg = ""
        return .none
    }
    
    private func handlePhoneOrPasswordBinding(state: inout State) -> Effect<Action> {
        state.isValid = !state.phone.isEmpty && !state.password.isEmpty
        state.errorMsg = ""
        return .none
    }
    
    private func handleProtocolConfirmed(state: inout State) -> Effect<Action> {
        // 关闭协议弹窗
        state.showProtocolSheet = false
        // 自动勾选协议
        state.$acceptProtocol.withLock { $0 = true }
        // 发送验证码
        return sendVerificationCode(phone: state.phone)
    }
}



