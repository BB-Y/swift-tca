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
        var protocolCheck: Bool = false
        
        /// x显示其他登录方式
        var shouldShowLoginAndSignup = false
        @Shared(.shareUserToken) var token = ""
        @Shared(.shareUserInfo) var userInfo = nil


        var userInfoModel: UserInfo? {
            if let userInfoModel = userInfo?.decode(to: UserInfo.self) {
                return userInfoModel
            }
            
            return nil
        }
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case login(SDLoginReducer)
        case signup(SDSignupReducer)
        
        case phoneValidate(SDValidatePhoneReducer)
    }
    
    enum Action: BindableAction {
        case showHome
        case showLogin
        case showSignup
        case onOtherLoginTapped
        
        
        case binding(BindingAction<State>)
        case path(StackActionOf<Destination>)
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            
            case .onOtherLoginTapped:
                state.shouldShowLoginAndSignup.toggle()
                return .none
            case .showHome:
                return .run {_ in
                    await dismiss()
                }
            
                
//                state.path.removeAll()
//                return .none
                
            case .showLogin:
                state.path.append(.login(SDLoginReducer.State()))
                return .none
                
            case .showSignup:
                state.path.append(.signup(SDSignupReducer.State()))
                return .none
                
            case .binding(_):
                return .none
                
            case .path(.element(id: _, action: .login(.showHome))):
                
                return .run {_ in
                    await dismiss()
                }
            case .path(.element(id: _, action: .login(.onForgetTapped))):
                state.path.append(.phoneValidate(SDValidatePhoneReducer.State()))

                return .none

                
            case .path(.element(id: _, action: .signup(.showHome))):
                state.path.removeAll()
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Destination.body
        }
    }
}



