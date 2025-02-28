//
//  SDValidatePhoneView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDValidatePhoneReducer {
    
    @ObservableState
    struct State: Equatable {
        var phone: String = ""
        var nation: String = "86"
        var code: String = ""

        var isValidPhone: Bool = false //登录按钮是否可用
        var isValidCode: Bool = false //登录按钮是否可用

        var isCountdown = false //倒计时
        var countNumber = 60
        
        var errorMsg = ""
    }
    
    enum Action: BindableAction {
        case onSendTapped
        
        case onConfirmTapped
        
        case onSendAgainTapped
        
        
        case phoneValidateResponse(Result<PhoneValidateResponse, APIError>)
        
        case setPhone(String)
        
        case binding(BindingAction<State>)
    }
    @Dependency(\.userClient) var userState
    
    @Dependency(\.continuousClock) var clock

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.phone):
                print(state.phone.count)
                if state.phone.count > 11 {
                    let text = state.phone.subString(form: 0, to: 11)
                    return .run { send in
                        await send(.setPhone(text))
                    }
                }
                
                
                return .none
                
            case .setPhone(let phone):
                print("setPhone called \(phone)")

                state.phone = phone
                
                print("new phone called \(state.phone)")

                if isValidPhone(phone) {
                    state.isValidPhone = true
                }
                return .none

            default:
                return .none
            }
        }
    }
    
    // 验证手机号格式
    private func isValidPhone(_ phone: String) -> Bool {
        
        // 简单验证：11位数字
        return phone.count == 11 && phone.allSatisfy { $0.isNumber }
    }
}
struct SDValidatePhoneView: View {
    @Perception.Bindable var store: StoreOf<SDValidatePhoneReducer>
    @State var isPresented = false
    var body: some View {
        VStack {
            
            SDPhoneInputView("请输入手机号", phone: $store.code, nationCode: $store.nation)
            
            Button {
                isPresented.toggle()
                store.send(.onSendTapped)
            } label: {
                Text("发送验证码")
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: !store.isValidPhone))

        }
        
        .navigationDestination(isPresented: $isPresented) {
            SDValidateCodeView(store: store)
        }
    }
}
struct SDValidateCodeView: View {
    @Perception.Bindable var store: StoreOf<SDValidatePhoneReducer>
    var body: some View {
        VStack {
            
            SDPhoneInputView("请输入验证码", phone: $store.phone, nationCode: $store.nation)
            
            Button {
                store.send(.onSendTapped)
            } label: {
                Text("确定")
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: !store.isValidPhone))

        }
    }
}

#Preview {
    
    SDValidatePhoneView(store: Store(initialState: SDValidatePhoneReducer.State(), reducer: {
        SDValidatePhoneReducer()
    }))
}
extension String {
   func subString (form start : Int, to end: Int) -> String {
     guard start >= 0, end <= self.count, start <= end else {
        return "Not valid index";
     }
     let startIndex = self.index(self.startIndex, offsetBy: start);
     let endIndex = self.index(self.startIndex, offsetBy: end);
     return String(self[startIndex..<endIndex]);
   }
 }
