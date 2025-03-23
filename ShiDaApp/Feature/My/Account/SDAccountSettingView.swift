//
//  SDAccountSettingView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SDAccountSettingReducer.self)
struct SDAccountSettingView: View {
    @Perception.Bindable var store: StoreOf<SDAccountSettingReducer>
    
    var body: some View {
        ZStack(alignment: .top) {
            SDColor.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // 基本信息区域
                    basicInfoSection
                    
                    // 绑定信息区域
                   bindingSection
                   
                    // 退出登录区域
                   logoutSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            
            if store.errorMessage != nil {
                SDErrorView(config: .networkError())
            }
        }
        .sdAlert(isPresented: $store.showLogoutAlert,
                 title: "退出登录",
                 message: "确定要退出当前账号吗？",
                 buttons: [
                    .init(title: "取消", style: .cancel, action: { send(.cancelAlert) }),
                    .init(title: "确定", style: .destructive, action: { send(.confirmLogout) })
                 ])
        .toolbarBackground(Color.clear, for: .navigationBar)
        .navigationTitle("账号设置")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            send(.onAppear)
        }
        
        .sdAlert(isPresented: $store.showUnbindAlert,
                 title: "解绑账号",
                 message: "要解除账号的绑定吗？",
                 buttons: [
                    .init(title: "取消", style: .cancel, action: { send(.cancelAlert) }),
                    .init(title: "确定", style: .destructive, action: { send(.confirmUnbind) })
                 ])
    }
    
    
    
    // 基本信息区域
    var basicInfoSection: some View {
        VStack(spacing: 0) {
            // 手机号
            settingRow(title: "手机号", value: store.phoneNumber, showArrow: false)
            
            SDLine(SDColor.divider1)
            
            NavigationLink(state: MyFeature.Path.State.verificationType) {
                settingRow(title: "修改密码", value: "", showArrow: true)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // 绑定信息区域
    var bindingSection: some View {
        VStack(spacing: 0) {
            Text("绑定信息")
                .font(.sdBody3)
                .foregroundStyle(SDColor.text3)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                
                // 微信账号
                bindingRow(
                    title: "微信账号",
                    isBound: store.isWechatBound,
                    bindType: .wechat
                )
                
                SDLine(SDColor.divider1)
                
                // QQ账号
                bindingRow(
                    title: "QQ账号",
                    isBound: store.isQQBound,
                    bindType: .qq
                )
                
                SDLine(SDColor.divider1)
                
                // Apple账号
                bindingRow(
                    title: "Apple账号",
                    isBound: store.isAppleBound,
                    bindType: .apple
                )
            }
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    // 退出登录区域
    var logoutSection: some View {
        VStack(spacing: 0) {
            settingRow(title: "注销账号", value: "", showArrow: true)
                .onTapGesture {
                    send(.deleteAccountTapped)
                }
            SDLine(SDColor.divider1)

            settingRow(title: "退出登录", value: "", showArrow: true)
                .onTapGesture {
                    send(.logoutTapped)

                }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // 设置行
    func settingRow(title: String, value: String, showArrow: Bool = true) -> some View {
        HStack {
            Text(title)
                .font(.sdBody1.weight(.medium))
                .foregroundStyle(SDColor.text1)
            Spacer()
            if value.isEmpty == false {
                Text(value)
                    .font(.sdBody1)
                    .foregroundStyle(title == "手机号" ? SDColor.text1 : SDColor.text3)
            }
            
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(SDColor.text3)
            }
        }
        .frame(height: 54)
    }
    
    // 绑定行
    func bindingRow(title: String, isBound: Bool, bindType: SDThirdPartyType) -> some View {
        settingRow(title: title, value: isBound ? "已绑定" : "未绑定", showArrow: true)
            .onTapGesture {
                send(.bindAccountTapped(bindType))

            }
    }
}

#Preview {
    NavigationStack {
        SDAccountSettingView(
            store: Store(
                initialState: SDAccountSettingReducer.State(),
                reducer: {
                    SDAccountSettingReducer()
                        ._printChanges()
                }
            )
        )
    }
}
