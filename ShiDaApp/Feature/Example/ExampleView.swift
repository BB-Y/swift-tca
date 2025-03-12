////
////  ExampleView.swift
////  ShiDaApp
////
////  Created by 黄祯鑫 on 2025/3/9.
////
//
//import SwiftUI
//import ComposableArchitecture
//import Combine
//// 定义一个共享的依赖
//struct CounterTimerClient {
//    var startTimer: @Sendable () -> Void
//    var stopTimer: @Sendable () -> Void
//}
//
//extension CounterTimerClient: DependencyKey {
//    static var liveValue = CounterTimerClient(
//        startTimer: { },
//        stopTimer: { }
//    )
//}
//
//extension DependencyValues {
//    var counterTimer: CounterTimerClient {
//        get { self[CounterTimerClient.self] }
//        set { self[CounterTimerClient.self] = newValue }
//    }
//}
//@Reducer
//struct CounterReducer {
//    @Dependency(\.counterTimer) var counterTimer
//    
//    struct State: Equatable {
//        var count = 0
//    }
//    
//    enum Action {
//        case increment
//        case decrement
//    }
//    
//    var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .increment:
//                state.count += 1
//                if state.count == 5 {
//                    return .run { _ in
//                        await counterTimer.startTimer()
//                    }
//                }
//                return .none
//            case .decrement:
//                state.count -= 1
//                return .none
//            }
//        }
//    }
//}
//
//@Reducer
//struct TimerReducer {
//    struct State: Equatable {
//        var secondsElapsed = 0
//        var isRunning = false
//    }
//    
//    enum Action {
//        case toggleTimer
//        case timerTick
//        case start
//        case stop
//    }
//    
//    var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .start:
//                state.isRunning = true
//                return .none
//            case .stop:
//                state.isRunning = false
//                return .none
//            case .toggleTimer:
//                state.isRunning.toggle()
//                return .none
//            case .timerTick:
//                if state.isRunning {
//                    state.secondsElapsed += 1
//                }
//                return .none
//            }
//        }
//    }
//}
//// 第一个子功能的 Reducer
//
//
//
//
//// 主 Reducer，组合两个子 Reducer
//@Reducer
//struct ExampleReducer {
//    struct State: Equatable {
//        var aaa = "''"
//        var counter = CounterReducer.State()
//        var timer = TimerReducer.State()
//    }
//    
//    enum Action {
//        case counter(CounterReducer.Action)
//        case timer(TimerReducer.Action)
//    }
//    
//    var body: some Reducer<State, Action> {
//        Scope(state: \.counter, action: \.counter) {
//            CounterReducer()
//        }
//        Scope(state: \.timer, action: \.timer) {
//            TimerReducer()
//        }
//        
//        // 配置依赖
//        Reduce { state, action in
//            return .none
//        }
//        .dependency(\.counterTimer, CounterTimerClient(
//            startTimer: {
//            
//            }, stopTimer: {
//            
//            }
//        ))
//        .reduce(into: &<#T##_#>, action: <#T##_#>)
//    }
//}
//
//
//// 视图实现
//struct ExampleView: View {
//    let store: StoreOf<ExampleReducer>
//    
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            VStack(spacing: 20) {
//                // Counter 部分
//                VStack {
//                    Text("计数器: \(viewStore.counter.count)")
//                    HStack {
//                        Button("减少") {
//                            viewStore.send(.counter(.decrement))
//                        }
//                        Button("增加") {
//                            viewStore.send(.counter(.increment))
//                        }
//                    }
//                }
//                
//                Divider()
//                
//                // Timer 部分
//                VStack {
//                    Text("计时器: \(viewStore.timer.secondsElapsed)秒")
//                    Button(viewStore.timer.isRunning ? "停止" : "开始") {
//                        viewStore.send(.timer(.toggleTimer))
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    ExampleView(
//        store: Store(
//            initialState: ExampleReducer.State()
//        ) {
//            ExampleReducer()
//        }
//    )
//}
