import Foundation
import ComposableArchitecture

@Reducer
struct SDSetNewPasswordReducer {
    enum Scene: Equatable {
        case resetByForget  // 未登录用户通过忘记密码重置
        case resetByCode    // 已登录用户通过验证码重置
        case resetByOld     // 已登录用户通过旧密码重置
    }
    
    @ObservableState
    struct State: Equatable {
        let scene: Scene
        var oldPassword = ""
        var password = ""
        var confirmPassword = ""
        var isLoading = false
        var errorMsg = ""
        var phone: String?
        var code: String?

        var canSubmit: Bool {
            let baseValidation = !password.isEmpty && 
                !confirmPassword.isEmpty && 
                password == confirmPassword &&
                password.count >= 6 && 
                password.count <= 16 &&
                password.isValidPassword
            
            switch scene {
            case .resetByForget:
                return baseValidation && phone != nil && code != nil
            case .resetByCode:
                return baseValidation && code != nil
            case .resetByOld:
                return baseValidation && !oldPassword.isEmpty
            }
        }
        
        init(scene: Scene, phone: String? = nil, code: String? = nil) {
            self.scene = scene
            self.phone = phone
            self.code = code
        }
    }
   
    enum Action: BindableAction, ViewAction {
        case binding(BindingAction<State>)
        case view(View)
        case delegate(Delegate)
        case `internal`(Internal)
        
        enum Internal {
            case resetPasswordResponse(Result<Bool, Error>)
            case resetPasswordByCodeResponse(Result<Bool, Error>)
            case resetPasswordByOldResponse(Result<Bool, Error>)
        }
        
        enum Delegate {
            case resetPasswordSuccess
        }
        
        enum View {
            case submitButtonTapped
        }
    }
    
    @Dependency(\.authClient) var authClient
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .submitButtonTapped:
                    state.isLoading = true
                    
                    switch state.scene {
                    case .resetByForget:
                        guard let phone = state.phone, let code = state.code else {
                            state.isLoading = false
                            state.errorMsg = "手机号或验证码不能为空"
                            return .none
                        }
                        
                        let request = SDReqParaForgetPassword(phoneNum: phone, password: state.password, smsCode: code)
                        
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
                        
                    case .resetByCode:
                        guard let code = state.code else {
                            state.isLoading = false
                            state.errorMsg = "验证码不能为空"
                            return .none
                        }
                        
                        return .run {[password = state.password] send in
                            await send(
                                .internal(
                                    .resetPasswordByCodeResponse(
                                        Result {
                                            try await userClient.resetPasswordByCode(password, code)
                                        }
                                    )
                                )
                            )
                        }
                        
                    case .resetByOld:
                        return .run {[password = state.password, oldPassword = state.oldPassword] send in
                            await send(
                                .internal(
                                    .resetPasswordByOldResponse(
                                        Result {
                                            try await userClient.resetPasswordByOld(password, oldPassword)
                                        }
                                    )
                                )
                            )
                        }
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
                    
                case .resetPasswordByCodeResponse(let .success(success)):
                    state.isLoading = false
                    if success {
                        return .send(.delegate(.resetPasswordSuccess))
                    } else {
                        state.errorMsg = "重置密码失败"
                        return .none
                    }
                    
                case .resetPasswordByOldResponse(let .success(success)):
                    state.isLoading = false
                    if success {
                        return .send(.delegate(.resetPasswordSuccess))
                    } else {
                        state.errorMsg = "修改密码失败"
                        return .none
                    }
                    
                case .resetPasswordResponse(.failure(let error)),
                     .resetPasswordByCodeResponse(.failure(let error)),
                     .resetPasswordByOldResponse(.failure(let error)):
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
