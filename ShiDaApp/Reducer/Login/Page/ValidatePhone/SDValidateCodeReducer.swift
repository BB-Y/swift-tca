
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
        
        @Shared var isCounting: Bool
        @Shared var currentNumber: Int
        
        
        // 添加初始化方法接收共享状态
        init(phone: String, isCounting: Shared<Bool>, currentNumber: Shared<Int>) {
            self.phone = phone
            self._isCounting = isCounting
            self._currentNumber = currentNumber
        }
    }
    
    enum Action: BindableAction {
        case onConfirmTapped
        case onSendAgainTapped
        case setCode(String)

        case checkCodeResponse(Result<Bool, Error>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onDisappear
        enum Delegate {
           case validateSuccess(phone: String, code: String)
            case onSendAgainTapped
       }
    }
    
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.authClient) var authClient
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        
        Reduce { state, action in
            switch action {
            
            case .binding(\.code):
                let code = state.code
                
                // 如果超过6位，截取前6位
                if code.count > 6 {
                    return .run { send in
                        await send(.binding(.set(\.code, code.prefix(6).description)))
                    }
                }
                
                // 检查是否为6位数字，并且不在倒计时中
                state.isValidCode = code.isValidSixNumber
                return .none

            case .onSendAgainTapped:
                return .send(.delegate(.onSendAgainTapped))

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
                
          
         
                
            
            
            default:
                return .none
            }
        }
        
      
    }
}
