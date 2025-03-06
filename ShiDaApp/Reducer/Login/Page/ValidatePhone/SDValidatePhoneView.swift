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
        var phone: String = ""
        var nation: String = "86"
        var code: String = ""
        
        var isValidPhone: Bool = false //登录按钮是否可用
        var isValidCode: Bool = false //登录按钮是否可用
        
        
        var errorMsg = ""
        
        var countDownState = SDCountDownReducer.State(startNumber: 5)
        
        var sendButtonText: String {
            if let isCounting = countDownState.isCounting {
                if isCounting {
                    return "重新发送(\(countDownState.currentNumber)s)"
                } else {
                    return "重新发送"

                }
            } else {
                return "发送验证码"
            }
        }
    }
    
    enum Action: BindableAction {
        case onSendTapped
        
        case onConfirmTapped
        
        case onSendAgainTapped
        
        case phoneValidateResponse(Result<Bool, Error>)
        
        case setPhone(String)
        
        case countDownAction(SDCountDownReducer.Action)
        
        case binding(BindingAction<State>)
    }
    
    
    @Dependency(\.continuousClock) var clock
    
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        Scope(state: \.countDownState, action: \.countDownAction) {
            SDCountDownReducer()
        }
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
           
                
            case .onSendTapped, .onSendAgainTapped:
                // 发送验证码时启动倒计时
                
                if state.countDownState.isCounting == true {
                    return .none
                }
                return .send(.countDownAction(.start))
           
                
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
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 48)
            SDLargeTitleView("验证手机号")
            Spacer()
                .frame(height: 32)
            SDPhoneInputView("请输入手机号", phone: $store.phone, nationCode: $store.nation)
            Spacer()
                .frame(height: 40)
            Button {
                isPresented.toggle()
                store.send(.onSendTapped)
            } label: {
                Text(store.sendButtonText)
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: !store.isValidPhone))
            Spacer()
            
        }
        .padding(.horizontal, 40)
        .navigationDestination(isPresented: $isPresented) {
            SDValidateCodeView(store: store)
        }
    }
}
struct SDValidateCodeView: View {
    @Perception.Bindable var store: StoreOf<SDValidatePhoneReducer>
    var body: some View {
        VStack(alignment: .center,spacing: 0) {
            Spacer()
                .frame(height: 48)
            SDLargeTitleView("请输入验证码")
            Spacer()
                .frame(height: 8)
            Text("已发送6位验证码至 +\(store.nation) \(store.phone)")
                .font(.sdBody3)
                .foregroundStyle(SDColor.text3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 32)
            VerificationCodeView(code: $store.code)
            
            Spacer()
                .frame(height: 40)
            Button {
                store.send(.onSendTapped)
            } label: {
                Text("确定")
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: !store.isValidPhone))
            Spacer()
                .frame(height: 24)
            Button {
                store.send(.onSendAgainTapped)
            } label: {
                Text(store.sendButtonText)

            }
            .font(.sdBody1)

            .buttonStyle(SDButtonStyleDisabled())

            .disabled(store.countDownState.isCounting == true)
            
            
            Spacer()
        }
        .padding(.horizontal, 40)
        
    }
}

#Preview {
    NavigationStack {
        SDValidatePhoneView(store: Store(initialState: SDValidatePhoneReducer.State(), reducer: {
            SDValidatePhoneReducer()
        }))
    }
    
}
#Preview {
    NavigationStack {
        SDValidateCodeView(store: Store(initialState: SDValidatePhoneReducer.State(), reducer: {
            SDValidatePhoneReducer()
        }))
    }
    
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


