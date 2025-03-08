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
    
    enum Action: BindableAction,ViewAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case delegate(Delegate)
        case `internal`(InternalAction)
        
        enum ViewAction {
            case submitButtonTapped
        }
        
        enum InternalAction {
            case resetPasswordResponse(Result<Bool, Error>)
        }
        
        @CasePathable
        enum Delegate {
            case resetPasswordSuccess
        }
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .submitButtonTapped:
                    state.isLoading = true
                    let request = SDReqParaForgetPassword(phoneNum: state.phone, password: state.password, smsCode: state.code)
                    
                    return .run { send in
                        await send(
                            .internal(
                                .resetPasswordResponse(
                                    Result {
                                        try await authClient.resetPassword(request)
                                    }
                                )
                            )
                        )
                    }
                }
                
            case let .internal(action):
                switch action {
                    
                case .resetPasswordResponse(let .success(success)):
                    state.isLoading = false
                    if success {
                        return .send(.delegate(.resetPasswordSuccess))
                    } else {
                        state.errorMsg = "重置密码失败"
                        return .none
                    }
                case .resetPasswordResponse(.failure(let error)):
                    state.isLoading = false
                    state.errorMsg = error.localizedDescription
                    return .none
                }
            
                
                
            case .binding(_):
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
