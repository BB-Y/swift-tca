
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDValidateCodeReducer {
    @ObservableState
    struct State: Equatable {
        var phone: String
        var nation: String = "+86"
        var code: String = ""
        var isValidCode: Bool = false
        var errorMsg = ""
        
        // 修改为接收共享状态
        @Shared var sendCodeState: SDSendCodeReducer.State
        
        // 添加初始化方法接收共享状态
        init(phone: String, sendCodeState: Shared<SDSendCodeReducer.State>) {
            self.phone = phone
            self._sendCodeState = sendCodeState
        }
    }
    
    enum Action: BindableAction {
        case onConfirmTapped
        case onSendAgainTapped
        case setCode(String)
        case sendCode(SDSendCodeReducer.Action)
        case checkCodeResponse(Result<Bool, Error>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onDisappear
        enum Delegate {
           case validateSuccess(phone: String, code: String)
       }
    }
    
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.authClient) var authClient
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.sendCodeState, action: \.sendCode) {
            SDSendCodeReducer()
        }
        
        Reduce { state, action in
            switch action {
            

            case .onDisappear:
                return .send(.sendCode(.countDown(.reset)))

            case .sendCode(.delegate(.countDownFinish)):
                state.isValidCode = state.phone.isValidSixNumber
                return .none
            case .sendCode(.delegate(.countDownStart)):
                state.isValidCode = false
                return .none
            case .onSendAgainTapped:
                return .send(.sendCode(.sendCode))

            case .onConfirmTapped:
                return .run { [phone = state.phone, code = state.code] send in
                    await send(.checkCodeResponse(Result { try await self.authClient.validatePhone(.init(phone: phone, smsCode: code)) }))
                }
                
            case .checkCodeResponse(.success(let check)):
                if check {
                    return .send(.delegate(.validateSuccess(phone: state.phone, code: state.code)))
                }
                state.errorMsg = "验证失败"
                return .none
                
          
                
            case .sendCode(.delegate(.sendSuccess)):
                state.errorMsg = ""
                return .none
                
            case .sendCode(.delegate(.sendFailure(let error))):
                state.errorMsg = error
                return .none
                
            
            
            default:
                return .none
            }
        }
        
      
    }
}
