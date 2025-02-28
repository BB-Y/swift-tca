//
//  SDLoginView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct SDLoginReducer {
    
    @ObservableState
    struct State: Equatable {
        var phone: String = ""
        var nationCode: String = "86"

        var password: String = ""
        var isPhone: Bool = true //手机号登录或密码登录
        var isLoading: Bool = false
        var isValid: Bool = false //登录按钮是否可用
        var errorMsg: String = ""
        var showPassword = false
        
        var isFlipping = false //翻转动画

        @Shared(.shareUserToken) var token = ""
        @Shared(.shareUserInfo) var userInfo = nil

    }
    
    enum Action: BindableAction {
        case login
        case showSignup
        case onForgetTapped
        case showHome
        case loginResponse(Result<UserInfo, APIError>)
        case eyeTapped
        case toggleLoginType
        case binding(BindingAction<State>)
    }
    @Dependency(\.userClient) var userState
    
    @Dependency(\.continuousClock) var clock

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleLoginType:
                
                
                    let currentIsPhone = state.isPhone

                
                // 使用 Effect 来处理延迟操作
                return .run { send in
                    
                    await send(.binding(.set(\.isFlipping, true)))

                    try await clock.sleep(for: .seconds(0.3))
                    
                    await send(.binding(.set(\.isPhone, !currentIsPhone)))
                    
                    // 重置相关状态
                    await send(.binding(.set(\.password, "")))
                    await send(.binding(.set(\.errorMsg, "")))
                    await send(.binding(.set(\.isValid, false)))
                    
                    try await clock.sleep(for: .seconds(0.3))
                    await send(.binding(.set(\.isFlipping, false)))

                    
                }
                //.animation(.easeInOut(duration: 1))
                
                
            case .eyeTapped:
                state.showPassword.toggle()
                return .none
            case .login:
                state.isLoading = true
                state.errorMsg = ""
                
                // 验证输入
                if state.phone.isEmpty {
                    state.errorMsg = state.isPhone ? "请输入手机号" : "请输入用户名"
                    state.isLoading = false
                    return .none
                }
                
                // 验证手机号格式
                if state.isPhone && !isValidPhone(state.phone) {
                    state.errorMsg = "请输入正确的手机号"
                    state.isLoading = false
                    return .none
                }
                
                if state.password.isEmpty {
                    state.errorMsg = "请输入密码"
                    state.isLoading = false
                    return .none
                }
                
                // 模拟登录请求
                return .run { [phone = state.phone, isPhone = state.isPhone] send in
                    do {
                        // 模拟网络延迟
                        try await self.clock.sleep(for: .seconds(1))
                        
                        // 创建模拟用户信息
                        let userInfo = UserInfo.init(id: "1", username: "hzx", email: "123", avatarUrl: "12121", createdAt: nil, updatedAt: nil)
                        
                        await send(.loginResponse(.success(userInfo)))
                    } catch {
                        await send(.loginResponse(.failure(error as! APIError)))
                    }
                }
                
            case let .loginResponse(.success(userInfoModel)):
                state.isLoading = false
                state.isValid = true
                // 更新全局用户状态
                let data = Data.getData(from: userInfoModel)
                state.$userInfo.withLock({$0 = data})

                state.$token.withLock({$0 = "token get"})
                return .run { send in
                    await send(.showHome)
                }
                
            case let .loginResponse(.failure(error)):
                state.isLoading = false
                state.isValid = false
                state.errorMsg = error.localizedDescription
                return .none
                
//            case .showSignup:
//                return .none
//                
            case .onForgetTapped:
                // 处理忘记密码
                state.errorMsg = ""
                return .none
                
            case .showHome:
                state.isValid = true
                state.errorMsg = ""
                return .none

//                state.$login.withLock {login in
//                    login = false}
//                return .run { _ in
//                    await dismiss()
//                }

                
            case .binding(\.isFlipping):
                return .none
            case .binding(\.phone):
                state.isValid = !state.phone.isEmpty && !state.password.isEmpty
                state.errorMsg = ""
                return .none
                
            case .binding(\.password):
                state.isValid = !state.phone.isEmpty && !state.password.isEmpty
                state.errorMsg = ""
                return .none
                
            case .binding:
                // 处理其他绑定操作
                return .none
            case .binding(_):
                
                return .none
            default:
                return .none
            }
        }
    }
    
    // 验证手机号格式
    private func isValidPhone(_ phone: String) -> Bool {
        // 简单验证：11位数字
        return phone.count == 11 && phone.allSatisfy { $0.isNumber }
    }
}


struct SDLoginView: View {
    @Perception.Bindable var store: StoreOf<SDLoginReducer>
    @State var showUrl: String?
    @State private var isFlipping = false
    
    
    var showPassword: Bool {
        if !store.state.isPhone {
            return store.state.showPassword
        } else {
            return true
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 48)
            Text(!store.isPhone ? "密码登录" : "验证码登录")
                .font(.largeTitle)
                .foregroundStyle(SDColor.text1)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
                
            
            Spacer()
                .frame(height: 32)
            
            SDPhoneInputView("请输入手机号", phone: $store.phone, nationCode: $store.nationCode)
            
            
            Spacer()
                .frame(height: 24)
            WithPerceptionTracking {
                SDSecureField(store.isPhone ? "请输入验证码" : "请输入密码", text: $store.password, isSecure: !store.isPhone)
                                    .padding(.horizontal, 16)
                                    .background {
                                        SDColor.background
                                            .clipShape(Capsule())
                                    }
            }
           
//            if store.state.isPhone {
//                TextField("请输入验证码", text: $store.password)
//                    .keyboardType(store.isPhone ? .numberPad : .default)
//                    .modifier(SDTextFieldWithClearButtonModefier(text: $store.password))
//                    .frame(height: 50)
//                    .padding(.horizontal, 16)
//                    .background {
//                        SDColor.background
//                            .clipShape(Capsule())
//                    }
//            } else {
//                SDSecureField(placeHolder: store.isPhone ? "请输入验证码" : "请输入密码", text: $store.password, showText: showPassword) {
//                    store.send(.eyeTapped)
//                }
//                .keyboardType(store.isPhone ? .numberPad : .default)
//            }
            Spacer()
                .frame(height: 16)
            // 修改登录方式切换按钮
            HStack {
                Button(action: {
//                    withAnimation(.easeInOut(duration: 0.3)) {
//                        isFlipping = true
//                                    }
//                                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            isFlipping = false
//                        }
//                    }
                    store.send(.toggleLoginType)
                }) {
                    HStack(spacing: 2) {
                        Text(store.isPhone ? "密码登录" : "验证码登录")
                        Image("icon_switch_password")
                    }
                }
                .foregroundStyle(SDColor.text3)
               

                Spacer()
                if !store.isPhone {
                    Button("忘记密码?") {
                        store.send(.onForgetTapped)
                    }
                    
                }
            }
            .font(.sdBody3)

            
            
            
            
            
            Spacer()
                .frame(height: 40)
            
            Button {
                store.send(.login)
            } label: {
                Text("登录")
                    
            }
            // 移除 disabled 修饰符，改为根据状态使用不同样式
            .buttonStyle(SDButtonStyleConfirm(isDisable: store.isLoading || !store.isValid))
            
            Spacer()
                .frame(height: 24)
            Text("我已阅读并同意[《用户协议》](https://baidu.com)[《隐私政策》](https://baidu.com)[《儿童/青少年个人信息保护政策》](https://baidu123.com)")
                .font(.sdSmall1)
                .foregroundStyle(SDColor.text3)
                .environment(\.openURL, OpenURLAction { url in
                    self.showUrl = url.absoluteString
                    return .handled
                })
           
            
            
            Spacer()
            
            VStack(spacing: 40) {
                
                HStack(spacing: 40){
                    Image("login_weixin")
                    Image("login_qq")
                    Image("login_apple")
                }
                .background(alignment: .top) {
                    HStack {
                        SDLine(SDColor.divider)
                        Text("其它登录方式")
                            .font(.sdSmall1)
                            .foregroundStyle(SDColor.text3)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                        SDLine(SDColor.divider)
                    }
                    .offset(x:0, y: -50)
                }
            }
            Spacer()
                .frame(height: 40)
            HStack(spacing: 0) {
                Text("还没有账号？")
                    .foregroundStyle(SDColor.text1)
                Button("去注册") {
                    store.send(.showSignup)
                }
                .foregroundStyle(SDColor.accent)
                
            }
            .font(.sdBody3)
            Spacer()
                .frame(height: 40)
            
        }
        .padding(.horizontal, 40.pad(134))
//        .rotation3DEffect(
//            .degrees(store.isFlipping ? 180 : 0),
//            axis: (x: 0.0, y: 1.0, z: 0.0)
//        )
      
        .transition(.opacity)
        //.animation(.easeInOut(duration: 0.6), value: store.isFlipping)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {

                }) {
                    Image("back")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    store.send(.showHome)
                }) {
                    Image("close")
                }
            }
        }
        //.animation(.easeInOut(duration: 0.6), value: store.isFlipping)
        
    }
}

#Preview {
    NavigationStack {
        SDLoginView(store: Store(initialState: SDLoginReducer.State(), reducer: {
            SDLoginReducer()
        }))
        .navigationTitle("")
        


    }
    .tint(SDColor.accent)
    
    
}








