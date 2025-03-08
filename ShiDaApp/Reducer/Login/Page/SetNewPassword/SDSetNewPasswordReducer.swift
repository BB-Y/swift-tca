import Foundation
import ComposableArchitecture

@Reducer
struct SDSetNewPasswordReducer {
    @ObservableState
    struct State: Equatable {
        var password = ""
        var confirmPassword = ""
        var isLoading = false
        var errorMsg = ""
        var phone: String
        var code: String

        var canSubmit: Bool {
            !password.isEmpty && 
            !confirmPassword.isEmpty && 
            password == confirmPassword &&
            password.count >= 6 && 
            password.count <= 16 &&
            password.isValidPassword
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onSubmitButtonTapped
        case resetPasswordResponse(Result<Bool, Error>)
        case delegate(Delegate)
        
        enum Delegate {
            case resetPasswordSuccess
        }
    }
    @Dependency(\.authClient) var authClient        // 认证客户端

    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
    
            case .onSubmitButtonTapped:
//                guard state.canSubmit else {
//                    state.errorMsg = "请检查后再试"
//                    return .none
//                }
                state.isLoading = true
                let request = SDReqParaForgetPassword(phoneNum: state.phone, password: state.password, smsCode: state.code)
                
                
                return .run { send in
                    await send(
                        .resetPasswordResponse(
                            Result { 
                                try await authClient.resetPassword(request)
                            }
                        )
                    )
                }
                
            case let .resetPasswordResponse(.success(success)):
                state.isLoading = false
                if success {
                    return .send(.delegate(.resetPasswordSuccess))
                } else {
                    state.errorMsg = "重置密码失败"
                    return .none
                }
                
            case let .resetPasswordResponse(.failure(error)):
                state.isLoading = false
                state.errorMsg = error.localizedDescription
                return .none
            case .binding(_):
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
