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
    private enum CancelID {
        case timer
    }
    
    @ObservableState
    struct State: Equatable {
        let startNumber: Int
        var isCounting: Bool  = false
        var currentNumber = 0
        // 添加一个唯一标识符，确保计时器不会被错误取消
        let id = UUID()
        init(startNumber: Int) {
            self.startNumber = startNumber
            
        }
    }
    
    enum Action: BindableAction {
        case start
        case stop
        case reset  // 添加重置动作
        case binding(BindingAction<State>)
        
        
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .start:
                
                
                state.currentNumber = state.startNumber
                let initialCount = state.currentNumber
                let timerId = state.id  // 使用唯一ID作为标识
                
                return .run { send in
                    await send(.binding(.set(\.isCounting, true)))
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
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .stop:
                
                
                return .merge(
                    .cancel(id: CancelID.timer),
                    .run { send in
                        await send(.binding(.set(\.isCounting, false)))
                    }
                )
                
            case .reset:  // 添加重置逻辑
                state.isCounting = false
//                state.currentNumber = 0
//                return .cancel(id: CancelID.timer)
                return .none

            case .binding(_):
                return .none
            }
        }
       
    }
}
