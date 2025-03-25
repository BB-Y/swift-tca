//
//  SDMyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyFeature {
    @ObservableState
    struct State: Equatable {
        
        var path: StackState<Path.State> = StackState<Path.State>()

        // 我的页面的状态
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserInfo) var userInfo = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        @Shared(.shareUserToken) var token = nil


        var showFeedBack: Bool = false
        var unreadMessageCount: Int = 0  // 添加未读消息数量状态
        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case favorites(SDFavoritesFeature)
        case corrections(SDCorrectionsFeature)
        case accountSettings(SDAccountSettingReducer)
        case teacherCertification(TeacherCertificationFeature)
        case aboutUs(AboutUsFeature)  // 修改这里
        case bookDetail(SDBookDetailReducer)
        case accountDelete(SDAccountDeleteFeature)  // 添加注销账号路由
        case messages(SDMessagesFeature)  // 添加消息页面路由

        case phoneValidate(SDValidatePhoneReducer)
        case codeValidate(SDValidateCodeReducer)
        
        @ReducerCaseIgnored
        case verificationType
        case password(SDSetNewPasswordReducer)
    }
    
    
    enum View {
        case onAppear
        
        case onEditTapped
        case onMessageTapped
        case onFavoritesTapped
        case onCorrectionsTapped
        case onAccountSettingsTapped
        case onTeacherCertificationTapped
        case onHelpFeedbackTapped
        case onAboutUsTapped
    }
    
    enum Action: BindableAction, ViewAction {
        // 我的页面的动作
       
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)

        case view(View)
        
        // 添加获取未读消息数量的 Action
        case fetchUnreadMessageCountResponse(Result<Int, Error>)
    }
    
    @Dependency(\.myClient) var myClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
           
            case let .view(viewAction):
                switch viewAction {
                

                case .onEditTapped:
                    return .none
                    
                case .onMessageTapped:
                    state.path.append(.messages(SDMessagesFeature.State()))
                    return .none

                case .onAppear:
                    return .run { send in
                        await send(.fetchUnreadMessageCountResponse(
                            Result { try await myClient.getUnreadMessageCount() }
                        ))
                    }
                   
                case .onFavoritesTapped:
                    state.path.append(.favorites(SDFavoritesFeature.State()))
                    return .none
                case .onCorrectionsTapped:
                    state.path.append(.corrections(SDCorrectionsFeature.State()))
                    return .none
                case .onAccountSettingsTapped:
                    state.path.append(.accountSettings(SDAccountSettingReducer.State()))
                    return .none
                case .onTeacherCertificationTapped:
                    state.path.append(.teacherCertification(TeacherCertificationFeature.State()))
                    return .none
                case .onHelpFeedbackTapped:
                    state.showFeedBack = true
                    return .none
                case .onAboutUsTapped:
                    state.path.append(.aboutUs(AboutUsFeature.State()))
                    return .none

                }
     
            case .path(StackAction.element(id: _, action: .accountSettings(.delegate(.deleteAccount)))):
                state.path.append(.phoneValidate(SDValidatePhoneReducer.State(sendCodeType: .verify)))
                return .none

            
            case let .path(StackAction.element(id: _, action: .phoneValidate(.delegate(.sendSuccess(phone, type))))):
                state.path.append(.codeValidate(SDValidateCodeReducer.State(phone: phone, sendCodeType: type)))
                return .none

            case let .path(StackAction.element(id: _, action: .codeValidate(.delegate(.validateSuccess(phone, code, sendCodeType))))):
                switch sendCodeType {
                
                case .changePassword:
                    state.path.append(.password(SDSetNewPasswordReducer.State(scene: .resetByCode, code: code)))
                case .verify:
                    state.path.append(.accountDelete(SDAccountDeleteFeature.State()))

                default:
                    return .none
                }
                return .none
                
            case .path(StackAction.element(id: _, action: .password(.delegate(.resetPasswordSuccess)))):
                state.path.removeAll()
                return .none
            case .path, .binding:
                return .none

                // 处理获取未读消息数量的响应
                         case let .fetchUnreadMessageCountResponse(.success(count)):
                             state.unreadMessageCount = count
                             return .none
                             
                         case .fetchUnreadMessageCountResponse(.failure):
                             // 处理错误，可以选择不做任何事或者设置默认值
                             
                             return .none
            }
        
        }
       
        .forEach(\.path, action: \.path)

    }
}



@ViewAction(for: MyFeature.self)
struct SDMyView: View {
    @Perception.Bindable var store: StoreOf<MyFeature>
    init(store: StoreOf<MyFeature>) {
        self.store = store
        SDAppearance.setup()
    }
    
    var body: some View {
        WithPerceptionTracking {
            
            
            NavigationStack (path: $store.scope(state: \.path, action: \.path)) {
                ZStack(alignment: .top) {
                    SDColor.background.ignoresSafeArea()
                    
                    Image(SDImage.My.myHeader)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        
                        
                        // 用户信息区域
                        HStack(alignment: .center, spacing: 16) {
                            AsyncImage(url: URL(string: /*store.userInfoModel?.avatar ??*/ "")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 64, height: 64)
                            .clipShape( Circle())
                            .background {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(Color.white)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Text(store.userInfoModel?.name ?? "")
                                        .font(.sdLargeTitle1)
                                        .fontWeight(.bold)
                                        .foregroundStyle(SDColor.text1)
                                    
                                    if store.userInfoModel?.userType == .teacher {
                                        if let authStatus = store.userInfoModel?.authStatus {
                                            switch authStatus {
                                            case .notApplied:
                                                Text("未认证")
                                                    .font(.sdSmall1.weight(.medium))
                                                    .foregroundColor(SDColor.error)
                                            case .pending:
                                                Text("认证中")
                                                    .font(.sdSmall1.weight(.medium))
                                                    .foregroundColor(SDColor.error)
                                            case .approved:
                                                HStack {
                                                    Text("教师")
                                                        .font(.sdSmall1.weight(.medium))
                                                        .foregroundStyle(Color.white)
                                                    Image(SDImage.My.teacherTag)

                                                }
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)

                                                .background {
                                                    Capsule()
                                                        .fill(SDColor.blue)
                                                }
                                            case .rejected:
                                                Text("未通过审核")
                                                    .font(.sdSmall1.weight(.medium))
                                                    .foregroundColor(SDColor.error)
                                            }
                                        }
                                       
                                        
                                            
                                    }
                                }
                                
                                Text(store.userInfoModel?.schoolName ?? "")
                                    .font(.sdBody2)
                                    .foregroundStyle(SDColor.text2)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // 编辑资料动作
                                send(.onEditTapped)
                            }) {
                                Image(SDImage.My.edit)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                        

                        // 菜单列表
                        List {
                            Section {
                                MenuRow(icon: SDImage.My.favorites, title: "我的收藏") {
                                    send(.onFavoritesTapped)
                                }
                                MenuRow(icon: SDImage.My.corrections, title: "我的纠错") {
                                    send(.onCorrectionsTapped)
                                }
                                MenuRow(icon: SDImage.My.accountSettings, title: "账号设置") {
                                    send(.onAccountSettingsTapped)
                                }
                                MenuRow(icon: SDImage.My.teacherCertification, title: "教师认证") {
                                    send(.onTeacherCertificationTapped)
                                }
                                
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .listRowSeparatorTint(SDColor.divider)

                            
                            
                            Section {
                                
                                MenuRow(icon: SDImage.My.helpFeedback, title: "帮助反馈") {
                                    send(.onHelpFeedbackTapped)
                                }
                                
                                MenuRow(icon: SDImage.My.aboutUs, title: "关于我们") {
                                    send(.onAboutUsTapped)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .listRowSeparatorTint(SDColor.divider)
                            //.listRowBackground(Color.white)

                        }
                        .scrollDisabled(true)
                        .scrollContentBackground(.hidden)
                        .listRowSpacing(0)
                        .listStyle(.insetGrouped)
                        .sdListSectionSpacing(16)
                
                        //.environment(\.defaultMinListHeaderHeight, 0.1) // <-- 2

                        Spacer()
                        // 版权信息
                        VStack(spacing: 6) {
                            Text("广西师范大学出版社 版权所有")
                            Text("Copyright© DXY.All Right Reserved")
                        }
                        .font(.sdSmall1)
                        .foregroundColor(SDColor.text3)
                        .padding(.bottom, 24)
                    }
                    
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // 消息按钮动作
                            send(.onMessageTapped)
                        }) {
                            Image(SDImage.My.message)
                                .overlay(alignment: .topTrailing) {
                                    NotificationBadge(count: store.unreadMessageCount)  // 传入未读消息数量
                                }
                        }
                        .frame(width: 32, height: 32, alignment: .center)
                        .padding(.trailing, 10)
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .sheet(isPresented: $store.showFeedBack, content: {
                    SDHelpFeedbackView()
                        .presentationDetents([.height(300)])
                        .presentationDragIndicator(.hidden)
                })
            }
            destination: { store in
                WithPerceptionTracking {
                    switch store.case {
                    case .favorites(let store):
                        SDFavoritesView(store: store)
                    case .corrections(let store):
                        SDCorrectionsView(store: store)
                    case .accountSettings(let store):
                        SDAccountSettingView(store: store)
                    case .teacherCertification(let store):
                        TeacherCertificationView(store: store)
                    case .messages(let store):
                        SDMessagesView(store: store)
                    case .aboutUs(let store):
                        SDAboutUsView(store: store)
                    case .bookDetail(let store):
                        SDBookDetailView(store: store)

                    case .accountDelete(let store):
                        SDAccountDeleteView(store: store)
                    case .phoneValidate(let store):
                        SDValidatePhoneView(store: store)
                    case .codeValidate(let store):
                        SDValidateCodeView(store: store)
                    case .password(let store):
                        SDSetNewPasswordView(store: store)
                    case .verificationType:
                        SDVerificationTypeView()
                   
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                
                
            }
            
            .tint(SDColor.text1)
            .task {
                send(.onAppear)
                SDAppearance.setup()
            }
        }
    }
}


@available(iOS 18.0, *)
#Preview {
    SDMyView(
        store: Store(
            initialState: MyFeature.State(),
            reducer: { MyFeature()._printChanges() }
        )
    )
}

// 菜单行组件
private struct MenuRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(icon)
                    
                    
                Text(title)
                    .font(.sdBody2.weight(.medium))
                    .foregroundStyle(SDColor.text1)
                Spacer()
                Image("arrow_right")
                    
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 54)  // 添加固定行高
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            return 0
        }
        .alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
            return viewDimensions[.listRowSeparatorTrailing]
        }
    }
}

// 通知红点组件
private struct NotificationBadge: View {
    var count: Int = 0
    
    var body: some View {
        if count > 0 {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: count > 9 ? 16 : 8, height: count > 9 ? 16 : 8)
                
                if count > 9 {
                    Text("9+")
                        .font(.system(size: 8))
                        .foregroundColor(.white)
                }
            }
            .offset(x: 2, y: -4)
        }
    }
}
