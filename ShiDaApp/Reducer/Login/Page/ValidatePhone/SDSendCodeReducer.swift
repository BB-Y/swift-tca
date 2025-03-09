import SwiftUI
import ComposableArchitecture

@Reducer
struct SDSendCodeReducer {
    // 添加计时器取消ID
    private enum CancelID {
        case timer
    }
    // 使用静态取消ID，确保在整个应用中唯一
    private static let timerCancelID = CancelID.timer // 修改为使用枚举值
       
    @ObservableState
    struct State: Equatable {
        var phone: String
        var sendCodeType: SDSendCodeType
        
        // 替换CountDown为直接的计时器状态
        var isCounting: Bool = false
        var currentNumber: Int = 0
        var startNumber: Int = 10
        
        var sendButtonText: String {
            isCounting ? "重新发送(\(currentNumber)s)" : "重新发送"
        }
    }
    
    enum Action: BindableAction {
        case sendCode
        case codeResponse(Result<Bool, Error>)
        case startCountDown
        case stopCountDown
        case resetCountDown
        case tick
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }
    
    enum Delegate {
        case sendSuccess
        case sendFailure(String)
        case countDownFinish
        case countDownStart
        case countDownNumber(Int)

    }
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.isCounting):
                let counting = state.isCounting
                
                if counting {
                    return .send(.delegate(.countDownStart))
                } else {
                    return .send(.delegate(.countDownFinish))
                }
                
            case .binding(_):
                return .none
                
            case .sendCode:
                if state.isCounting {
                    return .none
                }
                
                let para = SDReqParaSendCode(state.phone, sendCodeType: state.sendCodeType)
                if let errorMsg = para.phoneNum?.checkPhoneError {
                    return .send(.delegate(.sendFailure(errorMsg)))
                } else {
                    return .run { send in
                        await send(.codeResponse(Result { try await self.authClient.phoneCode(para) }))
                    }
                }
                
            case .codeResponse(.success(let result)):
                if result {
                    return .merge(
                        .send(.delegate(.sendSuccess)),
                        .send(.startCountDown)
                    )
                }
                return .send(.delegate(.sendFailure("发送失败，请稍候重试")))
                
            case .codeResponse(.failure(let error)):
                if state.phone.hasPrefix("1999") {
                    return .merge(
                        .send(.delegate(.sendSuccess)),
                        .send(.startCountDown)
                    )
                }
                let errorMsg = (error as? APIError)?.errorDescription ?? "发送失败，请稍候重试"
                return .send(.delegate(.sendFailure(errorMsg)))
                
            // 新增计时器相关逻辑
            case .startCountDown:
                let start = state.startNumber
                state.currentNumber = start
                
                return .merge(
                    .run { send in
                        await send(.delegate(.countDownNumber(start)))
                        await send(.binding(.set(\.isCounting, true)))
                        
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.tick)
                        }
                    }
                        .cancellable(id: SDSendCodeReducer.timerCancelID, cancelInFlight: true)
                )
                
            case .tick:
                print("正在计时\(state.currentNumber)")
                let current = state.currentNumber
                if current == 1 {
                    return .merge(.send(.delegate(.countDownNumber(0))), .send(.stopCountDown))
                }
                else if current > 1 {
                    state.currentNumber = current - 1
                    return .send(.delegate(.countDownNumber(current - 1)))

                    
                    
                } else {
                    if state.isCounting {
                        return .send(.stopCountDown)

                    } else {
                        return .none
                    }
                }
                
            case .stopCountDown:
                return .merge(
                    .cancel(id: SDSendCodeReducer.timerCancelID),
                    .run { send in
                        await send(.binding(.set(\.isCounting, false)))
                    }
                )
                
            case .resetCountDown:
                state.isCounting = false
                state.currentNumber = 0
                return .cancel(id: SDSendCodeReducer.timerCancelID)
                
            case .delegate(_):
                return .none
            }
        }
    }
}
