//
//  SDCountDownReducer.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation

import ComposableArchitecture
import Combine

@Reducer
struct SDCountDownReducer {
 
    @ObservableState
    struct State: Equatable {
        let startNumber: Int
        var isCounting: Bool?  = nil
        var currentNumber = 0
        
    }
    
    enum Action: BindableAction {
        case start
        case stop

        case binding(BindingAction<State>)
    }
    
    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .start:
                state.currentNumber = state.startNumber
                // 创建一个本地变量来跟踪倒计时
                let initialCount = state.currentNumber
                state.isCounting = true
                return .run { send in
                    var currentCount = initialCount
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        if currentCount > 0 {
                            currentCount -= 1
                            await send(.binding(.set(\.currentNumber, currentCount)))
                        } else {
                            await send(.stop)
                            break
                        }
                    }
                }
            case .stop:
                state.isCounting = false
                return .none

            case .binding(_):
                return .none
            }
        }
    }
}
