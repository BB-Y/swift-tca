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

        @Presents var login: SDLoginHomeReducer.State?

        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case favorites
        case corrections
        case accountSettings
        case teacherCertification
        case helpFeedback
        case aboutUs
    }
    
    
    enum View {
        case onAppear
        case onLogoutTapped
        case onRemoveUserTapped
        case onFavoritesTapped
        case onCorrectionsTapped
        case onAccountSettingsTapped
        case onTeacherCertificationTapped
        case onHelpFeedbackTapped
        case onAboutUsTapped
    }
    
    enum Action: ViewAction {
        // 我的页面的动作
       
        
        case path(StackActionOf<Path>)

        case view(View)
        
        case login(PresentationAction<SDLoginHomeReducer.Action>)

        case logout
        
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .logout:
                return .none
            case let .view(viewAction):
                switch viewAction {
                case .onLogoutTapped:
                    state.$loginStatus.withLock({$0 = .logout})
                    state.$token.withLock({$0 = nil})

                    state.$acceptProtocol.withLock({$0 = false})
                    state.path.removeAll()
                    state.login = SDLoginHomeReducer.State()
                    return .send(.logout)
                case .onRemoveUserTapped:
                    state.$loginStatus.withLock({$0 = .notLogin})
                    state.$userInfo.withLock({$0 = nil})
                    state.$acceptProtocol.withLock({$0 = false})
                    state.$token.withLock({$0 = ""})

                    state.path.removeAll()
                    state.login = SDLoginHomeReducer.State()
                    return .send(.logout)


                case .onAppear:
                    return .none
                case .onFavoritesTapped:
                    state.path.append(.favorites)
                    return .none
                case .onCorrectionsTapped:
                    state.path.append(.corrections)
                    return .none
                case .onAccountSettingsTapped:
                    state.path.append(.accountSettings)
                    return .none
                case .onTeacherCertificationTapped:
                    state.path.append(.teacherCertification)
                    return .none
                case .onHelpFeedbackTapped:
                    state.path.append(.helpFeedback)
                    return .none
                case .onAboutUsTapped:
                    state.path.append(.aboutUs)
                    return .none

                }
                return .none
                
            case .login(_):
                return .none
                
            case .path:
                return .none

            }
        
        }
        .ifLet(\.$login, action: \.login) {
            SDLoginHomeReducer()
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
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
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
            NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
                VStack(spacing: 0) {
                    // 顶部导航
                    HStack {
                        Spacer()
                        Button(action: {
                            // 消息按钮动作
                        }) {
                            Image(systemName: "envelope")
                                .foregroundColor(.primary)
                                .overlay(NotificationBadge())
                        }
                    }
                    .padding()
                    
                    // 用户信息区域
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: URL(string: /*store.userInfoModel?.avatar ??*/ "")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text(/*store.userInfoModel?.realName ??*/ "")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                if /*store.userInfoModel?.isTeacherCertified ??*/ false {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Text("未认证")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            Text(/*store.userInfoModel?.organization ??*/ "广西师范大学")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 编辑资料动作
                        }) {
                            Image(systemName: "pencil.circle")
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    // 菜单列表
                    List {
                        Section {
                            MenuRow(icon: "star.fill", title: "我的收藏") {
                                send(.onFavoritesTapped)
                            }
                            MenuRow(icon: "xmark.circle.fill", title: "我的纠错") {
                                send(.onCorrectionsTapped)
                            }
                            MenuRow(icon: "gear", title: "账号设置") {
                                send(.onAccountSettingsTapped)
                            }
                            MenuRow(icon: "link", title: "教师认证") {
                                send(.onTeacherCertificationTapped)
                            }
                        }
                        
                        Section {
                            MenuRow(icon: "questionmark.circle", title: "帮助反馈") {
                                send(.onHelpFeedbackTapped)
                            }
                            MenuRow(icon: "info.circle", title: "关于我们") {
                                send(.onAboutUsTapped)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    // 版权信息
                    VStack(spacing: 8) {
                        Text("广西师范大学出版社 版权所有")
                            .font(.caption2)
                        Text("Copyright© DXY.All Right Reserved")
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                    .padding(.vertical)
                }
            } destination: { state in
                switch state {
                case .favorites:
                    Text("我的收藏页面")
                case .corrections:
                    Text("我的纠错页面")
                case .accountSettings:
                    Text("账号设置页面")
                case .teacherCertification:
                    Text("教师认证页面")
                case .helpFeedback:
                    Text("帮助反馈页面")
                case .aboutUs:
                    Text("关于我们页面")
                }
            }
            
            .fullScreenCover(item: $store.scope(state: \.login, action: \.login), content: { item in
                WithPerceptionTracking {
                    SDLoginHomeView(store: item)
                }
            })
            .onAppear {
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
