//
//  SDBookDetailReducer.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDBookDetailReducer {
    @ObservableState
    struct State: Equatable {
        let id: Int
        
        // 图书详情状态
        var isLoading: Bool = false
        var bookDetail: SDBookDetailModel? = nil
        var errorMessage: String? = nil
        
        // 收藏状态
        var isFavorite: Bool = false
        
        // 当前选中的标签页
        enum TabSelection: Equatable, Hashable {
            case catalog, introduction, publishInfo
            var description: String {
                switch self {
                case .catalog:
                    return "目录"
                case .introduction:
                    return "图书简介"
                case .publishInfo:
                    return "出版信息"
                }
            }
        }
        var selectedTab: TabSelection = .catalog
        
        // 章节展开状态 (存储已展开的章节ID)
        var expandedChapters: Set<Int> = []
        
        
        var showTeacherAlert = false
        @Presents var login: SDLoginHomeReducer.State?

        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserInfo) var userInfoData = nil
        
        var userInfoModel: SDResponseLogin? {
            guard let data = userInfoData else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
    }
    
    enum View {
        case onAppear
        case onBackTapped
        case favoriteButtonTapped
        case chapterTapped(Int)
        case tabSelected(State.TabSelection)
        case applyForTeacherBook
        case buyPaperBook
        case startReading

    }
    
    enum Action: ViewAction, BindableAction {
        
        case binding(BindingAction<State>)
        case view(View)
        
        // 内部 Action
        case fetchBookDetail
        case bookDetailResponse(Result<SDBookDetailModel, Error>)
        case toggleFavorite
        case toggleFavoriteResponse(Result<Bool, Error>)
        
        // 导航相关 - 由父级 reducer 处理
        case delegate(Delegate)
        case login(PresentationAction<SDLoginHomeReducer.Action>)
        case toLogin
        enum Delegate {
            case navigateToChapterDetail(Int)
            case navigateToTeacherApply
            case navigateToBuyPaperBook
        }
    }
    
    @Dependency(\.bookClient) var bookClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.authClient) var authclient
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    if state.bookDetail != nil {
                        return .none
                    }
                    return .send(.fetchBookDetail)
                case .onBackTapped:
                return .run { _ in
                    await dismiss()
                }   
                case .favoriteButtonTapped:
                    if state.loginStatus.isLogin {
                        return .send(.toggleFavorite)
                    }
                    return .send(.toLogin)
                    
                case let .chapterTapped(chapterId):
                    if state.loginStatus == .login {
                        if state.expandedChapters.contains(chapterId) {
                            state.expandedChapters.remove(chapterId)
                        } else {
                            state.expandedChapters.insert(chapterId)
                        }
                    } else {
                        return .send(.toLogin)
                    }
                    return .none
                    
                case let .tabSelected(tab):
                    state.selectedTab = tab
                    return .none
                    
                case .applyForTeacherBook:
                    if state.loginStatus == .login {
                        return .send(.delegate(.navigateToTeacherApply))
                    }
                    if state.userInfoModel?.authStatus != .approved {
                        state.showTeacherAlert = true
                        return .none
                    }
                    return .send(.toLogin)
                    
                case .buyPaperBook:
                    if state.loginStatus == .login {
                        return .send(.delegate(.navigateToBuyPaperBook))
                    }
                    return .send(.toLogin)

                case .startReading:
                    if state.loginStatus == .login {
                        return .send(.delegate(.navigateToChapterDetail(1)))
                    }
                    return .send(.toLogin)
                }
                
            case .fetchBookDetail:
                state.isLoading = true
                return .run { [id = state.id] send in
                    await send(.bookDetailResponse(
                        Result {
                            try await bookClient.fetchBookDetail(id)
                        }
                    ))
                }
                
            case let .bookDetailResponse(.success(detail)):
                state.isLoading = false
                state.bookDetail = detail
                state.isFavorite = detail.isFavorite ?? false
                return .none
                
            case let .bookDetailResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .toggleFavorite:
                let newFavoriteState = !state.isFavorite
                
                return .run { [id = state.id, shouldFavorite = newFavoriteState] send in
                    await send(.toggleFavoriteResponse(
                        Result {
                            try await bookClient.toggleFavorite(id, shouldFavorite)
                        }
                    ))
                }
                
            case let .toggleFavoriteResponse(.success(isFavorite)):
                state.isFavorite = isFavorite
                return .none
                
            case .toggleFavoriteResponse(.failure):
                // 恢复原状态或显示错误提示
                return .none
                //弹出登录页面
            case .toLogin:
                state.login = SDLoginHomeReducer.State()
                return .none

            case .login(.presented(.loginDone)):
                return .send(.fetchBookDetail)

            case .delegate, .binding, .login:
                // 这些 action 会被父级 reducer 处理
                return .none
            }
        }
        .ifLet(\.$login, action: \.login) {
            SDLoginHomeReducer()
        }
    }
}
