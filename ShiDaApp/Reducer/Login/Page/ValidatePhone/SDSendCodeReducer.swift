import SwiftUI
import ComposableArchitecture

@Reducer
struct SDSendCodeReducer {
    @ObservableState
    struct State: Equatable {
        var phone: String
        var sendCodeType: SDSendCodeType
        
        
        var countDown = SDCountDownReducer.State(startNumber: 5)
        var sendButtonText: String {
            countDown.isCounting ? "重新发送(\(countDown.currentNumber)s)" : "重新发送"
        }
    }
    
    enum Action: BindableAction {  // 添加 BindableAction
        case sendCode
        case codeResponse(Result<Bool, Error>)
        case countDown(SDCountDownReducer.Action)
        case delegate(Delegate)
        case binding(BindingAction<State>)  // 新增
    }
    
    enum Delegate {
        case sendSuccess
        case sendFailure(String)
        case countDownFinish
        case countDownStart
        
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()  // 新增
        
        Scope(state: \.countDown, action: \.countDown) {
            SDCountDownReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .countDown(.binding(\.isCounting)):
                let counting = state.countDown.isCounting
                
                if counting {
                    return .send(.delegate(.countDownStart))
                } else {
                    return .send(.delegate(.countDownFinish))
                }
//                return .none
            case .binding(_):
                return .none

                // 在 Reduce 方法中添加对计时器完成的处理
            
                
                // 修改 sendCode 处理逻辑，确保事件传递
            case .sendCode:
                if state.countDown.isCounting == true {
                    return .none
                }
                let para = SDReqParaSendCode(state.phone, sendCodeType: state.sendCodeType)
                if let errorMsg = para.phoneNum?.checkPhoneError {
                    return .send(.delegate(.sendFailure(errorMsg)))
                } else {
                    // 先发送 countDownStart 事件，确保父级能收到
                    return .merge(
                        .send(.delegate(.countDownStart)),
                        .run { send in
                            await send(.countDown(.start))
                            await send(.codeResponse(Result { try await self.authClient.phoneCode(para) }))
                        }
                    )
                }
                
            case .codeResponse(.success(let result)):
                if result {
                    return .send(.delegate(.sendSuccess))
                }
                return .send(.delegate(.sendFailure("发送失败，请稍候重试")))
                
            case .codeResponse(.failure(let error)):
                //                if state.phone.hasPrefix("1999") {
                //                    return .send(.delegate(.sendSuccess))
                //                }
                let errorMsg = (error as? APIError)?.errorDescription ?? "发送失败，请稍候重试"
                return .send(.delegate(.sendFailure(errorMsg)))
            
            case .countDown(_):
                return .none

            case .delegate(_):
                return .none
            }
        }
    }
}
