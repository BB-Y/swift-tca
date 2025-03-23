//
//  SDAccountDeleteView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/20.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDAccountDeleteFeature {
    @ObservableState
    struct State: Equatable {
        var isAgreementChecked: Bool = false
        var showConfirmAlert: Bool = false
    }
    
    @Dependency(\.userClient) var userClient
    
    enum Action: BindableAction, ViewAction {
        case binding(BindingAction<State>)
        case view(View)
        case deleteAccountResponse(Result<Bool, Error>)
        case delegate(Delegate)
        enum Delegate {
            case deleteSuccess
        }
    }
    
    enum View {
        case onAgreementToggled
        case onDeleteAccountTapped
        case onConfirmDeleteTapped
        case onCancelTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAgreementToggled:
                    state.isAgreementChecked.toggle()
                    return .none
                    
                case .onDeleteAccountTapped:
                    if state.isAgreementChecked {
                        state.showConfirmAlert = true
                    }
                    return .none
                    
                case .onConfirmDeleteTapped:
                    state.showConfirmAlert = false
                    return .run { send in
                        await send(.deleteAccountResponse(
                            Result { try await userClient.deleteAccount() }
                        ))
                    }
                    
                case .onCancelTapped:
                    state.showConfirmAlert = false
                    return .none
                }
                
            case let .deleteAccountResponse(.success(success)):
                if success {
                    return .send(.delegate(.deleteSuccess))
                }
                return .none
                
            case .deleteAccountResponse(.failure):
                // 可以在这里添加错误提示
                return .none
                
            case .binding:
                return .none
            case .delegate(_):
                return .none

            }
            
            
        }
    }
}

@ViewAction(for: SDAccountDeleteFeature.self)
struct SDAccountDeleteView: View {
    @Perception.Bindable var store: StoreOf<SDAccountDeleteFeature>
    @Environment(\.dismiss) private var dismiss
    
    let tips = """
1.无法登录、使用独秀云账号，并移除该账号下所有登录方式。
2.账号头像重置为默认头像、昵称重置为“用户已注销”。
3.该账号下的个人资料和历史信息都将无法
找回。
4.取消认证教师身份且无法恢复
5.账号中所有的资产及权益被清除
6.无法继续进行商品交易、售后等流程
"""
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // 标题
                    Text("申请注销账号")
                        .font(.sdLargeTitle.weight(.medium))
                        .foregroundStyle(SDColor.text1)
                        .padding(.top, 34)
                    
                    // 注销须知
                    VStack(alignment: .leading, spacing: 20) {
                        Text("注销前请认真阅读以下重要提醒，账号注销后将无法再使用该账号，包括但不限于：")
                            .font(.sdBody2)
                            .foregroundStyle(SDColor.text1)
                            .lineSpacing(8)
                        
                        Text(tips)
                            .font(.sdBody3)
                            .foregroundStyle(SDColor.text2)
                            .lineSpacing(8)

                    }
                    VStack(alignment: .leading, spacing: 14) {
                        // 注销按钮
                        Button(action: {
                            send(.onDeleteAccountTapped)
                        }) {
                            Text("确认注销")
    
                                
                        }
                        .buttonStyle(.sdConfirmRed(isDisable: !store.isAgreementChecked))
                        .disabled(!store.isAgreementChecked)
                        
                        // 协议同意
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: {
                                send(.onAgreementToggled)
                            }) {
                                Image(store.isAgreementChecked ? "icon_check_red" : "icon_protocol_uncheck")
                                    .frame(width: 20, height: 20)
                            }
                            
                            SDLinkTextView(segments: [
                                .text("我已阅读并同意"),
                                .link("《独秀云账号注销须知》", url: "https://example.com/delete-account-terms")
                            ])
                            .font(.sdSmall1)
                            .foregroundStyle(SDColor.text3)
                            .tint(SDColor.warning)
                        }
                    }
                    
                    
                    
                    
                   
                    Spacer()

                }
                .padding(.horizontal, 40)
            }
            .navigationTitle("申请注销")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)

            .sdAlert(
                isPresented: $store.showConfirmAlert,
                title: "确认注销账号",
                message: "账号注销后将无法恢复，您确定要继续吗？",
                buttons: [
                    SDAlertButton(title: "取消", style: .cancel) {
                        send(.onCancelTapped)
                    },
                    SDAlertButton(title: "确认注销", style: .destructive) {
                        send(.onConfirmDeleteTapped)
                    }
                ]
            )
        }
    }
   
}

#Preview {
    NavigationStack {
        SDAccountDeleteView(
            store: Store(
                initialState: SDAccountDeleteFeature.State(),
                reducer: { SDAccountDeleteFeature() }
            )
        )
    }
}
