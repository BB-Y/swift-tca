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
        
        
        
//        
//        @Shared(.shareUserToken) var token = ""
//        @Shared(.shareUserInfo) var userInfoData = nil
//        
//        @Shared(.shareUserType) var userType = nil
//
//        var userInfo: SDResponseLogin? {
//            userInfoData?.decode(to: SDResponseLogin.self)
//        }
        
        @Shared(.shareLoginStatus) var loginStatus = .notLogin

    }
    
    @Reducer(state: .equatable)
    enum Destination {
        
        case login(SDLoginReducer)
        case phoneValidate(SDValidatePhoneReducer)
    }
    
    enum Action {
        
        case onCloseTapped
        
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
            case .path(.element(id: _, action: .login(.showHome))):
                
                return .run {_ in
                    await dismiss()
                }
            case .path(.element(id: _, action: .login(.onForgetTapped))):
                state.path.append(.phoneValidate(SDValidatePhoneReducer.State()))

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



