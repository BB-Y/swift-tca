//
//  BookPageReducer.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/22.
//
import SwiftUI
import ComposableArchitecture
@Reducer
struct BookPageReducer: Reducer {
    @ObservableState
    struct State: Equatable {
        // 学习页面的状态
        var nextPage : Int
        var prePage : Int
        var showMenu : Bool = false
    }
    
    enum Action: Equatable {
        // 学习页面的动作
        case turnNextPage
        case turnPrePage
        case showMenu
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .turnNextPage:
                state.nextPage += 1
                return .none
                
            case .turnPrePage:
                state.prePage += 1
                return .none
            case .showMenu:
                state.showMenu = !state.showMenu
                return .none
                
            }
        }
    }
}
