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
        
        @Shared(.shareUserToken) var token: String? = nil

        @Shared(.shareLoginStatus) var loginStatus = .notLogin
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

        case onLoginTapped
        
        
    }
    enum CancelID: Hashable {
        case loginStatusObservation
    }
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.mainQueue) var main
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .none
//                return .publisher {
//                    state.$loginStatus.publisher
//                        .map { status in
//                            
//                            return Action.onLoginStatusChanged
//                        }
//                        .receive(on: main)
//                }

           
            case .pushToTestView:
                state.path.append(.test(SDHomeTestFeature.State(page: "1")))
                return .none
                    
                //父级处理
            case .onLoginTapped:
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
                
            case .path(_):
                return .none
            }
        }
        
        .forEach(\.path, action: \.path)
    }
}


