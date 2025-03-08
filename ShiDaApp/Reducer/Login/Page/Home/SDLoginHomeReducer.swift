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
        
        @Shared(.shareLoginStatus) var loginStatus = .notLogin

      
        @Shared(.shareUserToken) var token = nil
        @Shared(.shareUserType) var userType = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        
        var loginAgain = SDLoginAgainReducer.State()
        var login = SDLoginReducer.State()
        var selectUserType = SDSelectUserTypeReducer.State()
        
        
        @Shared(.shareUserInfo) var userInfo = nil

        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
        
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        
        //case login(SDLoginReducer)
        case phoneValidate(SDValidatePhoneReducer)
        //case loginAgain(SDLoginAgainReducer)
        
        case selectUserType(SDSelectUserTypeReducer)
    }
    
    enum Action {
        
        case onCloseTapped
        case login(SDLoginReducer.Action)
        case loginAgain(SDLoginAgainReducer.Action)

        case checkUserType
        case path(StackActionOf<Destination>)
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
                
            case .onCloseTapped:
                
                return .run {_ in
                    await dismiss()
                }


            case .checkUserType:
                if state.userInfoModel?.userType == nil {
                    state.path.append(.selectUserType(SDSelectUserTypeReducer.State()))
                } else {
                    state.$loginStatus.withLock{$0 = .login}
                    return .send(.onCloseTapped)
                }
                //let data = state.$userInfo.wra
                
//                if let a = state.$userInfo.decode(type: SDResponseLogin.self, decoder: JSONDecoder()) {
//                    
//                }
                return .none
                
                
                
            case let .path(.element(id: _, action: .selectUserType(.onConfirmTapped(userType)))):
                state.$userType.withLock {
                    $0 = userType
                }
                return .send(.login(SDLoginReducer.Action.onLoginTapped))
            case .path:
                return .none
            case .login(let action):
                switch action {
               
                
                case .loginDone(.success(let userInfoModel)):
                    
                    if userInfoModel.token == nil {
                        state.$loginStatus.withLock({$0 = .notLogin})
                    } else {
                        if userInfoModel.userType == nil {
                            state.$loginStatus.withLock({$0 = .logout})
                        } else {
                            state.$loginStatus.withLock({$0 = .login})
                        }
                    }
                    
                    
                    // 更新全局用户状态
                    let data = Data.getData(from: userInfoModel)
                    state.$userInfo.withLock({$0 = data})
                    state.$loginStatus.withLock({$0 = .login})

                    state.$token.withLock({$0 = userInfoModel.token})
                    return .send(.checkUserType)
                case .loginDone(.failure(let error)):
                    print(error)

                case .onForgetTapped:
                    let phone = state.login.phone
                    state.path.append(.phoneValidate(SDValidatePhoneReducer.State(phone: phone)))
                    return .none

                default:
                    return .none
                }
                return .none
            

            case .loginAgain(let action):
                
                if case .onOtherLoginTapped = action {
                    state.showlogin = true
                }
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



