
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
        var errorMsg: String? = nil
        var sendCodeType: SDSendCodeType
        var isCounting: Bool = false
        var currentNumber: Int = 0
        
        var firstAppear = true
        @Shared(.shareUserInfo) var userInfo = nil

        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
        
        init(phone: String, sendCodeType: SDSendCodeType) {
            self.sendCodeType = sendCodeType
            self.phone = phone
            if sendCodeType == .changePassword, let phone = userInfoModel?.phone {
                self.phone = phone
            }
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        
        case subcribeCountdown
        
        case onConfirmTapped
        case onSendAgainTapped
        case setCode(String)

        case checkCodeResponse(Result<Bool, Error>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case countdownUpdated(isCounting: Bool, seconds: Int)
        case sendCodeResponse(Result<Bool, Error>)
        
        
        enum Delegate {
           case validateSuccess(phone: String, code: String, sendCodeType: SDSendCodeType)
       }
    }
    
    @Dependency(\.verificationCodeClient) var verificationCodeClient

    @Dependency(\.authClient) var authClient
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.firstAppear {
                    state.firstAppear.toggle()
                    return .merge(.send(.onSendAgainTapped), .send(.subcribeCountdown))
                }
                return .send(.subcribeCountdown)
            case .subcribeCountdown :
                return   .publisher {
                        verificationCodeClient.countdownPublisher
                            .map { Action.countdownUpdated(isCounting: $0.isCounting, seconds: $0.seconds) }
                    }
            case let .countdownUpdated(isCounting, seconds):
                state.isCounting = isCounting
                state.currentNumber = seconds
                return .none
                
            case .sendCodeResponse(.success):
                state.errorMsg = nil
                return .none
                
            case .sendCodeResponse(.failure(let error)):
//                if let verificationError = error as? VerificationCodeError {
//                    state.errorMessage = verificationError.errorDescription
//                } else {
//                    state.errorMessage = "发送失败，请稍后重试"
//                }
                return .none
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
                let phone = state.phone
                // 如果正在倒计时，不允许发送
                if state.isCounting {
                    return .none
                }
               

                return .run { [phone = state.phone, type = state.sendCodeType] send in
                    await send(.sendCodeResponse(
                        Result { try await verificationCodeClient.sendCode(phone: phone, type: type) }
                    ))
                }

            case .onConfirmTapped:
                return .run { [phone = state.phone, code = state.code] send in
                    await send(.checkCodeResponse(Result { try await self.authClient.validatePhone(.init(phone: phone, smsCode: code)) }))
                }
                
            case .checkCodeResponse(.success(let check)):
                if check {
                    return .send(.delegate(.validateSuccess(phone: state.phone, code: state.code, sendCodeType: state.sendCodeType)))
                }
                state.errorMsg = "验证失败"
                return .none
                
          
         
                
            
            
            default:
                return .none
            }
        }
        
      
    }
}
