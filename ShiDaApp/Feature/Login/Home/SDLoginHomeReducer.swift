//
//  SDLoginFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import Foundation
import ComposableArchitecture
import CodableWrappers

@Reducer
struct SDLoginHomeReducer {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Destination.State>()
        
        //登出状态切换其他登录方式
        var showlogin = false
        var errorMsg = ""
        
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserToken) var token = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        @Shared(.shareUserInfo) var userInfo = nil

        var loginAgain = SDLoginAgainReducer.State()
        var login = SDLoginReducer.State()
        
        init() {
            if loginStatus == .notLogin {
                showlogin = true
            }
        }
        
        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
        var userType: SDUserType?{
            userInfoModel?.userType
        }
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case phoneValidate(SDValidatePhoneReducer)
        case selectUserType(SDSelectUserTypeReducer)
        case resetPassword(SDSetNewPasswordReducer)
        case codeValidate(SDValidateCodeReducer)
    }
    
    enum Action {
        
        case onCloseTapped
        
        //scope
        case login(SDLoginReducer.Action)
        case loginAgain(SDLoginAgainReducer.Action)
        
        
        case saveUserInfo(SDResponseLogin)
        
        case checkUserType
        case path(StackActionOf<Destination>)
        
        case dismiss
        
        case loginDone
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // 重置密码成功后清空导航栈
            case .path(StackAction.element(id: _, action: .resetPassword(.delegate(.resetPasswordSuccess)))):
                state.path.removeAll()
                return .none
           
            // 手机号验证成功后跳转到重置密码页面
            case let .path(StackAction.element(id: _, action: .phoneValidate(.delegate(action)))):
                switch action {
                case let .sendSuccess(phone, type):
                    state.path.append(.codeValidate(SDValidateCodeReducer.State(phone: phone, sendCodeType: type)))
                    return .none

                }
            case let .path(StackAction.element(id: _, action: .codeValidate(.delegate(.validateSuccess(phone, code, sendCodeType))))):
                state.path.append(.resetPassword(SDSetNewPasswordReducer.State(scene: .resetByForget, phone: phone, code: code)))
                return .none

//            case .resetPassword(.delegate(.resetPasswordSuccess)):
//                state.path.removeAll()
//                return .none
            case .loginAgain(.delegate(let action)):
                switch action {
                case .userTypeNil:
                    state.errorMsg = "登录失败，请选择其他登录方式"
                case .loginSuccess(let userInfoModel):
                    
                    return .send(.saveUserInfo(userInfoModel))

                case .switchToOtherLogin:
                    state.showlogin = true
                }
                return .none

           
            case .onCloseTapped:
                
                return .send(.dismiss)

            case .dismiss:
                return .run {_ in
                    await dismiss()
                }
                
            // 检查用户类型并进行相应跳转
            case .checkUserType:
                if state.userInfoModel?.userType == nil {
                    state.path.append(.selectUserType(SDSelectUserTypeReducer.State()))
                }
            
                return .none
                
                
                
                //选择身份后回调, 一定是登录后才会选择身份，登出后再登录不会到这个流程
            case let .path(.element(id: _, action: .selectUserType(.onConfirmTapped(userType)))):
                if var user = state.userInfoModel {
                    user.userType = userType
                    state.$userInfo.withLock { $0 = Data.getData(from: user) }
                }
                return .send(.login(SDLoginReducer.Action.view(.onLoginTapped)))
           
                   // 处理登录成功后的操作
            case .saveUserInfo(let userInfoModel):
                
                // 根据返回的用户信息更新登录状态
                if userInfoModel.token == nil {
                    state.$loginStatus.withLock({$0 = .notLogin})
                    return .none
                } else {
                    // 更新全局用户状态
                    let data = Data.getData(from: userInfoModel)
                    state.$userInfo.withLock({$0 = data})
                    state.$token.withLock({$0 = userInfoModel.token})
                    if userInfoModel.userType == nil {
                        state.$loginStatus.withLock({$0 = .logout})
                        return .send(.checkUserType)
                    } else {
                        state.$loginStatus.withLock({$0 = .login})
                        return .run { send in
                            await send(.loginDone)
                            await send(.dismiss)
                        }
                    }
                  
                }
                
                
                
            case .login(.delegate(let action)):
                switch action {
                    
                case .loginSuccess(let userInfoModel):
                    return .send(.saveUserInfo(userInfoModel))
                case .loginFailed(let error):
                    print(error)
                    return .none
                case .forgetPassword:
                    let phone = state.login.phone
                    state.path.append(.phoneValidate(SDValidatePhoneReducer.State(phone: phone, sendCodeType: .forgetPassword)))
                    return .none
                
               
                }
                
                
           
                
                
            
                
            
           
            case .loginAgain, .login, .path, .loginDone:
                return .none
            
            }
        }
        .forEach(\.path, action: \.path) {
            Destination.body
        }
        Scope(state: \.login, action: \.login) {
            SDLoginReducer()
        }
        Scope(state: \.loginAgain, action: \.loginAgain) {
            SDLoginAgainReducer()
        }
    }
}



