//
//  SDSignupView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDSignupReducer {
    
    @ObservableState
    struct State: Equatable {
        var phone: String = ""
        var verificationCode: String = ""
        var isLoading: Bool = false
        var isValid: Bool = false
        var errorMsg: String = ""
        var countdownSeconds: Int = 0 // 倒计时秒数
        var isSendingCode: Bool = false // 是否正在发送验证码
        var currentStep: SignupStep = .phoneVerification // 当前注册步骤
    }
    
    enum SignupStep {
        case phoneVerification // 手机号验证步骤
        case codeVerification // 验证码输入步骤
    }
    
    enum Action: BindableAction {
        case sendVerificationCode
        case signup
        case showHome
        case countdown
        case sendCodeResponse(Result<Bool, APIError>)
        case signupResponse(Result<UserInfo, APIError>)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                //点击发送验证码
            case .sendVerificationCode:
                // 验证手机号
                if state.phone.isEmpty {
                    state.errorMsg = "请输入手机号"
                    return .none
                }
                
                // 验证手机号格式
                if !isValidPhone(state.phone) {
                    state.errorMsg = "请输入正确的手机号"
                    return .none
                }
                
                state.isSendingCode = true
                state.errorMsg = ""
                
                // 模拟发送验证码
                return .run { [phone = state.phone] send in
                    do {
                        // 模拟网络延迟
                        try await self.clock.sleep(for: .seconds(1))
                        
                        // 模拟发送成功
                        await send(.sendCodeResponse(.success(true)))
                    } catch {
                        await send(.sendCodeResponse(.failure(error as! APIError)))
                    }
                }
            default:
                return .none
                
//            case let .sendCodeResponse(result):
//                state.isSendingCode = false
//
//                switch result {
//                case .success(_):
//                    // 开始倒计时
//                    state.countdownSeconds = 60
//                    // 切换到验证码输入步骤
//                    state.currentStep = .codeVerification
//                    return .run { send in
//                        for _ in 1...60 {
//                            try await Task.sleep(nanoseconds: 1_000_000_000)
//                            await send(.countdown)
//                        }
//                    }
//                }
//                
//                return .none
//                
//            
//                
//                
//            case .countdown:
//                if state.countdownSeconds > 0 {
//                    state.countdownSeconds -= 1
//                }
//                return .none
//                
//            case .signup:
//                // 验证输入
//                if state.phone.isEmpty {
//                    state.errorMsg = "请输入手机号"
//                    return .none
//                }
//                
//                if !isValidPhone(state.phone) {
//                    state.errorMsg = "请输入正确的手机号"
//                    return .none
//                }
//                
//                if state.verificationCode.isEmpty {
//                    state.errorMsg = "请输入验证码"
//                    return .none
//                }
//                
//                if state.verificationCode.count != 6 {
//                    state.errorMsg = "验证码格式不正确"
//                    return .none
//                }
//                
//                state.isLoading = true
//                state.errorMsg = ""
//                
//                // 模拟注册请求
//                return .run { [phone = state.phone] send in
//                    do {
//                        // 模拟网络延迟
//                        try await Task.sleep(nanoseconds: 1_500_000_000)
//                        
//                        // 创建模拟用户信息
//                        let userInfo = UserInfo(
//                            id: "2",
//                            username: phone,
//                            email: nil,
//                            phone: phone
//                        )
//                        
//                        await send(.signupResponse(.success(userInfo)))
//                    } catch {
//                        await send(.signupResponse(.failure(error)))
//                    }
//                }
//                
//            case let .signupResponse(.success(userInfo)):
//                state.isLoading = false
//                state.isValid = true
//                // 更新全局用户状态
//                
//                return .run { send in
//                    await send(.showHome)
//                }
//                
//            case let .signupResponse(.failure(error)):
//                state.isLoading = false
//                state.isValid = false
//                state.errorMsg = error.localizedDescription
//                return .none
//                
//            case .showHome:
//                return .none
//                
//            case .binding(_):
//                state.errorMsg = ""
//                return .none
            }
        }
    }
    
    // 验证手机号格式
    private func isValidPhone(_ phone: String) -> Bool {
        // 简单验证：11位数字
        return phone.count == 11 && phone.allSatisfy { $0.isNumber }
    }
}

struct SDSignupView: View {
    @Perception.Bindable var store: StoreOf<SDSignupReducer>
    
    var body: some View {
        VStack(spacing: 16) {
            Text("注册")
                .font(.title)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            
            // 根据当前步骤显示不同的UI
            if store.currentStep == .phoneVerification {
                // 第一步：手机号验证
                phoneVerificationView
            } else {
                // 第二步：验证码输入
                codeVerificationView
            }
            
            if !store.errorMsg.isEmpty {
                Text(store.errorMsg)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .padding()
    }
    
    // 手机号验证视图
    private var phoneVerificationView: some View {
        VStack(spacing: 16) {
            // 手机号输入
            TextField("请输入手机号",text: $store.phone)
            
            // 发送验证码按钮
            Button(action: { 
                if store.countdownSeconds == 0 && !store.isSendingCode {
                    store.send(.sendVerificationCode)
                }
            }) {
                Text("发送验证码")
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .disabled(store.isSendingCode)
        }
    }
    
    // 验证码输入视图
    private var codeVerificationView: some View {
        VStack(spacing: 16) {
            // 显示已发送验证码的手机号
            Text("已发送6位验证码至 +86 \(store.phone)")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 验证码输入框
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    let digit = index < store.verificationCode.count ? String(Array(store.verificationCode)[index]) : ""
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Text(digit)
                            .font(.title2)
                    }
                }
            }
            .overlay(
                TextField("", text: $store.verificationCode)
                    .keyboardType(.numberPad)
                    .frame(width: 0, height: 0)
                    .opacity(0.01)
            )
            
            // 重新发送按钮
            Button(action: { 
                if store.countdownSeconds == 0 && !store.isSendingCode {
                    store.send(.sendVerificationCode)
                }
            }) {
                Text(buttonText)
                    .font(.caption)
                    .foregroundColor(store.countdownSeconds > 0 ? .gray : .green)
            }
            .disabled(store.countdownSeconds > 0 || store.isSendingCode)
            .padding(.top, 8)
            
            // 确定按钮
            Button("确定") {
                store.send(.signup)
            }
            
        }
    }
    
    private var buttonText: String {
        if store.isSendingCode {
            return "发送中..."
        } else if store.countdownSeconds > 0 {
            return "重新发送(\(store.countdownSeconds)s)"
        } else {
            return "发送验证码"
        }
    }
}

#Preview {
    SDSignupView(store: Store(initialState: SDSignupReducer.State(), reducer: {
        SDSignupReducer()
    }))
}
