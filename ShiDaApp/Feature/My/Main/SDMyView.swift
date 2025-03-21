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
        case aboutUs
        case bookDetail(SDBookDetailReducer)

    }
    
    
    enum View {
        case onAppear
        
        case onEditTapped
        
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
        
        
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
           
            case let .view(viewAction):
                switch viewAction {
                

                case .onEditTapped:
                    return .none

                case .onAppear:
                    return .none
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
                    state.path.append(.aboutUs)
                    return .none

                }
     
                
            case .path, .binding:
                return .none

            }
        
        }
       
        .forEach(\.path, action: \.path)

    }
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
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 8, height: 8)
            .offset(x: 2, y: -4)
    }
}

@ViewAction(for: MyFeature.self)
struct SDMyView: View {
    @Perception.Bindable var store: StoreOf<MyFeature>
    
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
                        }) {
                            Image(SDImage.My.message)
                                .overlay(alignment: .topTrailing) {
                                    NotificationBadge()
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
            } destination: { store in
                Group {
                    switch store.case {
                    case .favorites(let store):
                        SDFavoritesView(store: store)
                    case .corrections(let store):
                        SDCorrectionsView(store: store)
                    case .accountSettings(let store):
                        SDAccountSettingView(store: store)
                    case .teacherCertification(let store):
                        TeacherCertificationView(store: store)
                   
                    case .aboutUs:
                        Text("关于我们页面")
                    case .bookDetail(let store):
                        SDBookDetailView(store: store)
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                .toolbarRole(.editor)
                
            }
            .toolbarRole(.editor)
            
            .task {
                send(.onAppear)
            }
        }
    }
}


@available(iOS 18.0, *)
#Preview {
    SDMyView(
        store: Store(
            initialState: MyFeature.State(),
            reducer: { MyFeature() }
        )
    )
}
