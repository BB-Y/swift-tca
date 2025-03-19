import Foundation
import ComposableArchitecture

@Reducer
struct TeacherCertificationFeature {
    @ObservableState
    struct State: Equatable {
        // User info
        var name: String = "任怡"
        var phoneNumber: String = "15213363258"
        var email: String = ""
        var school: String = ""
        var department: String = ""
        var major: String = ""
        var position: String = ""
        var title: String = ""
        
        // Work ID documents
        var workIdImages: [Data] = []
        
        // Address info
        var address: String = ""
        var detailedAddress: String = ""
        var postalCode: String = ""
        
        // UI state
        var isAgreementChecked: Bool = false
        var isSubmitting: Bool = false
        var showImagePicker: Bool = false
        var alertMessage: String?
    }
    
    enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        // Input actions
        case emailChanged(String)
        case schoolChanged(String)
        case departmentChanged(String)
        case majorChanged(String)
        case positionChanged(String)
        case titleChanged(String)
        case addressChanged(String)
        case detailedAddressChanged(String)
        case postalCodeChanged(String)
        case agreementToggled
        
        // Document actions
        case addWorkIdImagesTapped
        case workIdImagesSelected([Data])
        case reuploadWorkIdImagesTapped
        
        // Flow actions
        case submitTapped
        case submitResponse(TaskResult<Bool>)
        case dismissAlert
        case backButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none

            case let .emailChanged(email):
                state.email = email
                return .none
                
            case let .schoolChanged(school):
                state.school = school
                return .none
                
            case let .departmentChanged(department):
                state.department = department
                return .none
                
            case let .majorChanged(major):
                state.major = major
                return .none
                
            case let .positionChanged(position):
                state.position = position
                return .none
                
            case let .titleChanged(title):
                state.title = title
                return .none
                
            case let .addressChanged(address):
                state.address = address
                return .none
                
            case let .detailedAddressChanged(address):
                state.detailedAddress = address
                return .none
                
            case let .postalCodeChanged(code):
                state.postalCode = code
                return .none
                
            case .agreementToggled:
                state.isAgreementChecked.toggle()
                return .none
                
            case .addWorkIdImagesTapped:
                state.showImagePicker = true
                return .none
                
            case let .workIdImagesSelected(images):
                state.workIdImages = images
                state.showImagePicker = false
                return .none
                
            case .reuploadWorkIdImagesTapped:
                state.showImagePicker = true
                return .none
                
            case .submitTapped:
                // Validation
                if !state.isAgreementChecked {
                    state.alertMessage = "请同意教师认证服务协议"
                    return .none
                }
                
                if state.school.isEmpty {
                    state.alertMessage = "请输入学校"
                    return .none
                }
                
                if state.department.isEmpty {
                    state.alertMessage = "请输入院系"
                    return .none
                }
                
                if state.workIdImages.isEmpty {
                    state.alertMessage = "请上传工作证照片"
                    return .none
                }
                
                state.isSubmitting = true
                
                // Submit the certification request
                return .run { [state] send in
                    // Simulate API call
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.submitResponse(.success(true)))
                }
                
            case .submitResponse(.success):
                state.isSubmitting = false
                state.alertMessage = "提交成功，请等待审核"
                return .none
                
            case .submitResponse(.failure):
                state.isSubmitting = false
                state.alertMessage = "提交失败，请稍后再试"
                return .none
                
            case .dismissAlert:
                state.alertMessage = nil
                return .none
                
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            }
        }
    }
}
