//
//  SDAccountSettingReducer.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDAccountSettingReducer {
    @ObservableState
    struct State: Equatable {
        // 用户信息
        var phoneNumber: String = ""
        
        var errorMessage: String? = nil
        
        // 绑定状态
        var isWechatBound: Bool = false
        var isQQBound: Bool = false
        var isAppleBound: Bool = false
        
       
        
        // 弹窗状态
        var showLogoutAlert: Bool = false
        var showUnbindAlert: Bool = false
        var currentUnbindType: SDThirdPartyType? = nil
        
        // 用户设置信息
        var userSettings: SDResponseUserInfo? = nil
        var isLoadingUserSettings: Bool = false
        
        
        
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserInfo) var userInfoData = nil
        @Shared(.shareUserToken) var userToken = nil

        var userInfoModel: SDResponseLogin? {
            guard let data = userInfoData else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
        
        func getBindStatus(for type: SDThirdPartyType) -> Bool {
            switch type {
            case .wechat:
                return isWechatBound
            case .qq:
                return isQQBound
            case .apple:
                return isAppleBound
            }
        }
    }
    
    enum Action: ViewAction, BindableAction {
        case binding(BindingAction<SDAccountSettingReducer.State>)
        case view(View)
        
        // 内部 Action
        case fetchUserInfo
        case fetchUserInfoResponse(Result<SDResponseUserInfo, Error>)
        case bindAccount(SDThirdPartyType)
        case unbindAccount(SDThirdPartyType)
        case bindAccountResponse(Result<Bool, Error>)
        case unbindAccountResponse(Result<Bool, Error>)
        
        // 导航相关 - 由父级 reducer 处理
        case delegate(Delegate)
        
        enum Delegate {
            case logout
            case navigateToModifyPassword
            case navigateToBindAccount(SDThirdPartyType)
        }
        enum View {
            case onAppear
            case modifyPasswordTapped
            case bindAccountTapped(SDThirdPartyType)
            case unbindAccountTapped(SDThirdPartyType)
            case logoutTapped
            case confirmLogout
            case confirmUnbind
            case cancelAlert
        }
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    return .send(.fetchUserInfo)
                    
                case .modifyPasswordTapped:
                    return .send(.delegate(.navigateToModifyPassword))
                    
                case let .bindAccountTapped(type):
                    if state.getBindStatus(for: type) {
                        state.currentUnbindType = type
                        state.showUnbindAlert = true
                        return .none
                    } else {
                        return .send(.delegate(.navigateToBindAccount(type)))
                    }
                    
                case let .unbindAccountTapped(type):
                    state.currentUnbindType = type
                    state.showUnbindAlert = true
                    return .none
                    
                case .logoutTapped:
                    state.showLogoutAlert = true
                    return .none
                    
                case .confirmLogout:
                    state.showLogoutAlert = false
                    return .send(.delegate(.logout))
                    
                case .confirmUnbind:
                    state.showUnbindAlert = false
                    if let type = state.currentUnbindType {
                        return .send(.unbindAccount(type))
                    }
                    return .none
                    
                case .cancelAlert:
                    state.showLogoutAlert = false
                    state.showUnbindAlert = false
                    state.currentUnbindType = nil
                    return .none
                }
                
            case .fetchUserInfo:
                state.isLoadingUserSettings = true
                return .run { send in
                    do {
                        let userSettings = try await userClient.getUserSettings()
                        await send(.fetchUserInfoResponse(.success(userSettings)))
                    } catch {
                        await send(.fetchUserInfoResponse(.failure(error)))
                    }
                }
                
            case let .fetchUserInfoResponse(.success(userSettings)):
                state.isLoadingUserSettings = false
                state.userSettings = userSettings
                
                // 更新电话号码
                state.phoneNumber = userSettings.phone ?? ""
                
                // 更新第三方账号绑定状态
                state.isWechatBound = false
                state.isQQBound = false
                state.isAppleBound = false
                
                if let thirdPartyAccounts = userSettings.thirdparthAccountList {
                    for account in thirdPartyAccounts {
                        if let bindType = account.thirdpartyBindType {
                            switch bindType {
                            case .wechat:
                                state.isWechatBound = true
                            case .qq:
                                state.isQQBound = true
                            case .apple:
                                state.isAppleBound = true
                            }
                        }
                    }
                }
                
                return .none
                
            case .fetchUserInfoResponse(.failure(let error)):
                state.isLoadingUserSettings = false
                state.errorMessage = "获取用户信息失败: \(error.localizedDescription)"
                return .none
                
            case let .bindAccount(type):
                return .none
                
            case let .unbindAccount(type):
                return .none
                
            case .bindAccountResponse(.success):
                return .send(.fetchUserInfo)
                
            case .unbindAccountResponse(.success):
                return .send(.fetchUserInfo)
                
          
                
           
                
            case .delegate, .binding, .bindAccountResponse(.failure), .unbindAccountResponse(.failure):
                return .none
            }
        }
    }
}


