//
//  SDMainTabView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/2.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDAppFeature {
    @ObservableState
    struct State {
        var selectedTab: SDTabItem = .home
        var homeState: SDHomeFeature.State = .init()
        var bookState: SDBookFeature.State = .init()
        var studyState: StudyFeature.State = .init()
        
        var myState: MyFeature.State = .init()
        @Presents var login: SDLoginHomeReducer.State?

        
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserToken) var token = nil
        @Shared(.shareUserInfo) var userInfo = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false


    }
//    @Dependency(\.navigation) var navigation
//    @Dependency(\.navigationPath) var navigationPath
    enum SDTabItem {
        case home
        case book
        case study
        case my
    }
    enum Action: BindableAction {
        case tabSelected(SDTabItem)
        case home(SDHomeFeature.Action)
        case book(SDBookFeature.Action)
        case study(StudyFeature.Action)
        case my(MyFeature.Action)
        
        case binding(BindingAction<State>)

        case login(PresentationAction<SDLoginHomeReducer.Action>)

        case clearLoginStatus
        case resetNavigation
        case showLogin

    }
    
    //@Dependency(\.)
    
    @Dependency(\.continuousClock) var clock

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        BindingReducer()
        //切片 Reducer
        Scope(state: \.homeState, action: \.home) {
            SDHomeFeature()
                ._printChanges()
        }
        Scope(state: \.bookState, action: \.book) {
            SDBookFeature()
        }
        Scope(state: \.studyState, action: \.study) {
            StudyFeature()
        }
        Scope(state: \.myState, action: \.my) {
            MyFeature()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                print(tab)
                print(state.selectedTab)
                let current = state.selectedTab
                if state.loginStatus != .login {
                    if tab == .study || tab == .my {
                        //state.selectedTab = .home
                        state.selectedTab = current
                        return .send(.showLogin)
                    } else {
                        state.selectedTab = tab
                    }
                } else {
                    state.selectedTab = tab
                }
                return .none
            case .home(.onLoginTapped):
                return .send(.showLogin)
            case .book(.onLoginTapped):
                return .send(.showLogin)
            case .my(MyFeature.Action.path(StackAction.element(id: _, action: .accountSettings(.delegate(.logout))))):
                
                return .run { send in
                    await send(.clearLoginStatus)
                    await send(.resetNavigation)
                    //await send(.showLogin)
                }
            case .my(MyFeature.Action.path(StackAction.element(id: _, action: .accountDelete(.delegate(.deleteSuccess))))):
                
                state.$loginStatus.withLock({$0 = .notLogin})
                state.$token.withLock({$0 = nil})
                state.$userInfo.withLock({$0 = nil})
                state.$acceptProtocol.withLock({$0 = false})
                
                return .send(.resetNavigation)
                
            case .clearLoginStatus:
                state.$loginStatus.withLock({$0 = .logout})
                state.$token.withLock({$0 = nil})

                state.$acceptProtocol.withLock({$0 = false})
                
                return .none
            case .resetNavigation:
                state.homeState.path.removeAll()
                state.bookState.path.removeAll()
                state.myState.path.removeAll()
                //state.studyState.path.removeAll()
                //state.selectedTab = .home

                return .run { send in
                    try await clock.sleep(for: .seconds(1))
                    await send(.binding(.set(\.selectedTab, .home)))
                }
            case .showLogin:
                state.login = SDLoginHomeReducer.State()
                return .none
                
            case .home, .book, .study, .my, .login, .binding:
                return .none
            }
        }
        //解包@Presents
        .ifLet(\.$login, action: \.login) {
            SDLoginHomeReducer()
        }
        
    }
}

struct SDAppView: View {
    @State var store: StoreOf<SDAppFeature>
    
    var body: some View {
        WithPerceptionTracking{
            VStack (spacing: 0){
                
    //            HStack {
    //                Text("网络错误")
    //            }
    //            .frame(height: 40)
    //            .frame(maxWidth: .infinity)
    //            .background {
    //                Color.red
    //            }
                
                TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
                    WithPerceptionTracking {
                        homeView
                        
                        bookView
                        
                        studyView
                        myView
                    }
                    
                    
                }
                .sdTint(SDColor.accent)
                
            }
            .ignoresSafeArea(.keyboard, edges:  .bottom)

            

        }
        
        
        .fullScreenCover(item: $store.scope(state: \.login, action: \.login), content: { item in
            WithPerceptionTracking {
                SDLoginHomeView(store: item)

            }
        })
        
        
    }
    // 首页
    var homeView: some View {
        SDHomeView(
            store: store.scope(
                state: \.homeState,
                action: \.home
            )
        )
        .tabItem {
            
            Label("首页", image: store.selectedTab == .home ? "home_tab_select" : "home_tab_deselect")
        }
        .tag(SDAppFeature.SDTabItem.home)
    }
    
    // 书籍
    var bookView: some View {
        SDBookHomeView(
            store: store.scope(
                state: \.bookState,
                action: \.book
            )
        )
        .tabItem {
            Label("书籍", image: store.selectedTab == .book ? "book_tab_select" : "book_tab_deselect")
        }
        .tag(SDAppFeature.SDTabItem.book)
    }
    
    // 学习
    var studyView: some View {
        StudyView(
            store: store.scope(
                state: \.studyState,
                action: \.study
            )
        )
        .tabItem {
            Label("学习", image: store.selectedTab == .study ? "study_tab_select" : "study_tab_deselect")
        }
        .tag(SDAppFeature.SDTabItem.study)
    }
    
    // 我的
    var myView: some View {
        SDMyView(
            store: store.scope(
                state: \.myState,
                action: \.my
            )
        )
        .tabItem {
            Label("我的", image: store.selectedTab == .my ? "my_tab_select" : "my_tab_deselect")
        }
        .tag(SDAppFeature.SDTabItem.my)
    }
}


#Preview {
    
    SDAppView(
        store: Store(
            initialState: SDAppFeature.State(),
            reducer: { SDAppFeature()._printChanges() }
        )
    )
}
