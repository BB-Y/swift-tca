//
//  SDValidatePhoneView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI
import ComposableArchitecture
import Combine

@Reducer
struct SDValidatePhoneReducer {
    
    @ObservableState
    struct State: Equatable {
        
        @Presents var inputCode: SDValidateCodeReducer.State?
        
        @Shared var sendCodeState: SDSendCodeReducer.State
        
        
        var sendCodeType: SDSendCodeType
        var phone: String = ""
        var nation: String = "86"
        var isValidButton: Bool = false
        var errorMsg: String = ""
        var buttonTitle = "发送验证码"
        
        init(phone: String = "", sendCodeType: SDSendCodeType) {
            self.phone = phone
            self.sendCodeType = sendCodeType
            //self.sendCodeState = .init(wrappedValue: .init(phone: phone, sendCodeType: sendCodeType))
            self._sendCodeState = Shared(value: SDSendCodeReducer.State.init(phone: phone, sendCodeType: sendCodeType))
            if phone.isValidPhoneNumber {
                isValidButton = true
            }
        }
    }
    
    enum Action: BindableAction {
        case inputCode(PresentationAction<SDValidateCodeReducer.Action>)
        
        
        case onSendTapped
        case setPhone(String)
        case sendCode(SDSendCodeReducer.Action)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        enum Delegate {
            case validateSuccess(phone: String, code: String)
        }
    }
    
    
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.sendCodeState, action: \.sendCode) {
            SDSendCodeReducer()
        }
        
        
        Reduce { state, action in
            switch action {
            case .inputCode(.dismiss):
                return .send(.sendCode(.countDown(.reset)))
            case .sendCode(.delegate(.countDownFinish)):
                state.isValidButton = state.phone.isValidPhoneNumber
                
                return .none
            case .sendCode(.delegate(.countDownStart)):
                //state.isValidButton = false
                
                return .none
            case .binding(\.phone):
                let phone = state.phone
                
                if phone.count > 11 {
                    return .run { send in
                        await send(.setPhone(phone.subString(form: 0, to: 11)))
                    }
                }
                
                state.isValidButton = phone.isValidPhoneNumber
                
                return .none
                
            case .setPhone(let phone):
                state.phone = phone
                return .none
                
            case .onSendTapped:
                let phone = state.phone
                state.$sendCodeState.withLock {
                    $0.phone = phone
                }
                return .send(.sendCode(.sendCode))
                
            case .sendCode(.delegate(.sendSuccess)):
                // 发送成功后跳转到验证码页面
                
                state.inputCode = SDValidateCodeReducer.State(phone: state.phone, sendCodeState: state.$sendCodeState)
                return .none
                
            case .sendCode(.delegate(.sendFailure(let error))):
                state.errorMsg = error
                return .none
                
            case .inputCode(.presented(.delegate(.validateSuccess(let phone, let code)))):
                
                return .send(.delegate(.validateSuccess(phone: phone, code: code)))
                
                //            case .destination(.presented(let action)):
                //                          switch action {
                //                          case .inputCode(let action):
                //                              switch action {
                //                              case .delegate(.validateSuccess(let phone, let code)):
                //                                  return .send(.delegate(.validateSuccess(phone: phone, code: code)))
                //                              default:
                //                                  return .none
                //                              }
                //                          }
                
                
                //return .send(.delegate(.validateSuccess(phone: phone, code: code)))
                
                //                switch action {
                //                case let .validateSuccess(phone, code):
                //                    return .send(.delegate(.validateSuccess(phone: phone, code: code)))
                //                }
                
                
                //            case let .codeView(.presented(.delegate(.validateSuccess(phone, code)))):
                //                return .send(.delegate(.validateSuccess(phone: phone, code: code)))
                
            default:
                return .none
            }
        }
        //        .ifLet(\.sendCodeState, action: \.sendCode) {
        //            SDSendCodeReducer()
        //        }
        .ifLet(\.$inputCode, action: \.inputCode) {
            SDValidateCodeReducer()
            // .dependency(\.sendCodeState, \.sendCodeState)
            
        }
        
        
        
        
    }
}
struct SDValidatePhoneView: View {
    @Perception.Bindable var store: StoreOf<SDValidatePhoneReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 48)
                SDLargeTitleView("验证手机号")
                Spacer()
                    .frame(height: 32)
                SDPhoneInputView("请输入手机号", phone: $store.phone, nationCode: $store.nation)
                Spacer()
                    .frame(height: 40)
                Text(store.errorMsg)
                    .font(.sdBody3)
                    .foregroundStyle(SDColor.error)
                    .frame(height: 10)
                Button {
                    store.send(.onSendTapped)
                } label: {
                    //Text("发送验证码")
                    WithPerceptionTracking {
                        Text(store.buttonTitle)
                    }
                }
                .buttonStyle(SDButtonStyleConfirm(isDisable: !store.isValidButton))
                Spacer()
                
                
            }
            .padding(.horizontal, 40)
            .navigationDestination(item: $store.scope(state: \.inputCode, action: \.inputCode)) { store in
                WithPerceptionTracking {
                    SDValidateCodeView(store: store)
                }
            }
            
            //            .navigationDestination(isPresented: $store.showCodeInput) {
            //                WithPerceptionTracking {
            //                    SDValidateCodeView(store: store)
            //                }
            //            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        SDValidatePhoneView(store: Store(initialState: SDValidatePhoneReducer.State(phone: "12211112222", sendCodeType: .bind), reducer: {
//            SDValidatePhoneReducer()
//        }))
//    }
//
//}

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


struct VerificationCodeView: View {
    @Binding var code: String
    let codeLength: Int
    
    @State private var isFocused: Bool = false
    @FocusState private var fieldFocus: Bool
    
    init(code: Binding<String>, codeLength: Int = 6) {
        self._code = code
        self.codeLength = codeLength
    }
    
    var body: some View {
        ZStack {
            
            
            HStack(spacing: 0) {
                ForEach(0..<codeLength, id: \.self) { index in
                    HStack {
                        DigitCell(
                            index: index,
                            code: $code,
                            isFocused: index == code.count && isFocused,
                            isSelected: index == code.count - 1 && isFocused
                        )
                    }
                    if index != codeLength - 1 {
                        Spacer()
                    }
                }
            }
            
            TextField("", text: $code)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .keyboardType(.numberPad)
                .focused($fieldFocus)
                .onChange(of: fieldFocus) { newValue in
                    isFocused = newValue
                }
                .onReceive(Just(code)) { newValue in
                    // 限制只能输入数字且最多输入codeLength位
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered.count > codeLength {
                        code = String(filtered.prefix(codeLength))
                    } else if filtered != newValue {
                        code = filtered
                    }
                }
        }
        .onTapGesture {
            fieldFocus = true
        }
    }
}

struct DigitCell: View {
    let index: Int
    @Binding var code: String
    let isFocused: Bool
    let isSelected: Bool
    // 添加光标闪烁状态
    @State private var cursorVisible: Bool = true
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? SDColor.accent : Color.clear, lineWidth: 1)
                .frame(width: 40, height: 50)
                .background {
                    SDColor.inputBackground
                        .cornerRadius(4)
                }
            
            if index < code.count {
                Text(String(Array(code)[index]))
                    .font(.sdTitle)
                    .foregroundColor(SDColor.text1)
            } else if isFocused {
                Rectangle()
                    .fill(SDColor.accent)
                    .frame(width: 2, height: 24)
                
                    .opacity(cursorVisible ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: cursorVisible)
                    .onAppear {
                        // 启动光标闪烁
                        cursorVisible.toggle()
                    }
            }
        }
    }
}




