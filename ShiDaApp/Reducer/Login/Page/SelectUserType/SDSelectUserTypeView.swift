//
//  SDSelectUserTypeView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDSelectUserTypeReducer {
    @ObservableState
    struct State: Equatable {
        var selectedType: SDUserType? = nil
    }

    enum Action {
        case onUserTypeTapped(SDUserType)
        case onConfirmTapped(SDUserType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .onUserTypeTapped(type):
                state.selectedType = type
                return .none
                
            case .onConfirmTapped(let type):
                // 这里可以添加确认按钮点击后的逻辑
                return .none
            }
        }
    }
}

struct SDSelectUserTypeView: View {
    @Perception.Bindable var store: StoreOf<SDSelectUserTypeReducer>
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            SDVSpacer(48)
            // 标题部分
            VStack(alignment: .leading, spacing: 8) {
                Text("请选择注册身份")
                    .font(.largeTitle.bold())
                    .foregroundStyle(SDColor.text1)
                
                Text("账号一经注册，身份将无法更改，请谨慎选择。")
                    .font(.sdBody3)
                    .foregroundStyle(SDColor.text3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            SDVSpacer(40)
            
            // 选择部分
            selectionSection
                .padding(.horizontal, 34)
            
            SDVSpacer(40)
            
            // 确认按钮
            confirmButton
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .navigationTitle("")
    }
    
    // MARK: - 视图组件
    
    // 选择部分
    private var selectionSection: some View {
        HStack(spacing: 90) {
            // 学生选项
            userTypeOption(
                type: .student,
                title: "我是学生",
                imageName: "user_type_student"
            )
            
            // 教师选项
            userTypeOption(
                type: .teacher,
                title: "我是教师",
                imageName: "user_type_teacher"
            )
        }
    }
    
    // 用户类型选项
    private func userTypeOption(type: SDUserType, title: String, imageName: String) -> some View {
        let isSelected = store.selectedType == type
        
        return VStack(spacing: 24) {
            Text(title)
                .font(.sdBody1)
                .foregroundStyle(SDColor.text1)
                
            Image(imageName)
                .resizable()
                .frame(width: 64, height: 64)
                .overlay(
                    Circle()
                        .stroke(isSelected ? SDColor.accent : Color.clear, lineWidth: 3)
                        .frame(width: 69, height: 69)
                )
                .onTapGesture {
                    store.send(.onUserTypeTapped(type))
                }
        }
    }
    
    // 确认按钮
    private var confirmButton: some View {
        Button {
            if let type = store.selectedType {
                store.send(.onConfirmTapped(type))
            }
        } label: {
            Text("确定")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(SDButtonStyleConfirm(isDisable: store.selectedType == nil))
    }
}

#Preview {
    NavigationStack {
        SDSelectUserTypeView(
            store: Store(initialState: SDSelectUserTypeReducer.State()) {
                SDSelectUserTypeReducer()
            }
        )
    }
    .tint(SDColor.accent)
}
