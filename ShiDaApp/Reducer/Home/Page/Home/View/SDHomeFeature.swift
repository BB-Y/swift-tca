//
//  SDHomeFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDHomeFeature {
    
    @ObservableState
    struct State: Equatable {
        
        
        // 首页的状态
        var homeData: String?

        var path: StackState<Path.State> = StackState<Path.State>()
        //= StackState<Path.State>()
        var isLoginViewShow = false
        
        @Presents var login: SDLoginHomeReducer.State?
        @Shared(.shareUserToken) var token: String = ""

    }
    
    @Reducer(state: .equatable)
    enum Path {
        
      case test(SDHomeTestFeature)
      
    }
    
    enum Action {
        // 首页的动作
        case onAppear
        case pushToTestView  // 添加新的 action
        case path(StackActionOf<Path>)
        case login(PresentationAction<SDLoginHomeReducer.Action>)

        case onLoginTapped
        
    }
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .none
            case .pushToTestView:
                state.path.append(.test(SDHomeTestFeature.State(page: "1")))
                return .none
                
            case .onLoginTapped:
                state.login = SDLoginHomeReducer.State()
                return .none
                
            case .path(.element(id: _, action: .test(.delegate(.nextPage(let page))))):
                
                state.path.append(.test(SDHomeTestFeature.State(page: page)))
                return .none
            case .path(.element(id: _, action: .test(.delegate(.pop)))):
                state.path.popLast()
                return .none
            case .path(.element(id: _, action: .test(.delegate(.popToRoot)))):
                
                state.path.removeAll()
                return .none

            // 添加对登录页关闭的处理
//            case .login(.presented(.showHome)),
//                 .login(.presented(.path(.element(id: _, action: .login(.showHome))))),
//                 .login(.presented(.path(.element(id: _, action: .signup(.showHome))))):
//                state.login = nil
//                return .none
                
            case .login:
                return .none
                
            case .path(_):
                return .none
            }
        }
        .ifLet(\.$login, action: \.login) {
            SDLoginHomeReducer()
        }
        .forEach(\.path, action: \.path)
    }
}


