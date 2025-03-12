//
//  SDHomeFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDHomeFeature {
    
    @ObservableState
    struct State: Equatable {
        // 首页的状态
        var homeData: [SDResponseHomeSection]?
        var path: StackState<Path.State> = StackState<Path.State>()
        @Shared(.shareSearchHistory) var searchHistoryString = ""
        
        // 搜索相关状态
        var searchText = ""
        var isSearchActive = false
        var isShowingSearchResults = false
        
        // 搜索结果组件状态
        var searchResultsFeature = SDSearchResultsFeature.State()
        
        var searchOverlay = SDSearchOverlayFeature.State()
        
        var isLoginViewShow = false
        
        @Shared(.shareUserToken) var token: String? = nil
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case test(SDHomeTestFeature)
        case bookList(SDBookListFeature)
        case schoolList(SDSchoolListFeature)
        case bookDetail(SDBookDetailReducer)
    }
    
    enum Action: BindableAction {
        // 绑定操作
        case binding(BindingAction<State>)
        
        // 首页的动作
        case onAppear
        case fetchHomeDataResponse(Result<[SDResponseHomeSection], Error>)
        
        case path(StackActionOf<Path>)
        
        // 搜索相关操作
        case toggleSearch
        case submitSearch
        case searchOverlay(SDSearchOverlayFeature.Action)
        case searchResultsFeature(SDSearchResultsFeature.Action)
        
        // 登录相关
        case onLoginTapped
        
        // 内容交互
        case onSectionItemTapped(SDResponseHomeListItem)
        case onSectionTitleTapped(SDResponseHomeSection)
        
       
    }
    
    enum CancelID: Hashable {
        case loginStatusObservation
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.mainQueue) var main
    @Dependency(\.homeClient) var homeClient
    @Dependency(\.searchClient) var searchClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.searchOverlay, action: \.searchOverlay) {
            SDSearchOverlayFeature()
        }
        
        Scope(state: \.searchResultsFeature, action: \.searchResultsFeature) {
            SDSearchResultsFeature()
        }
        
        Reduce { state, action in
            switch action {
                
                //MARK: - home data
            case .onAppear:
                return .run { send in
                    await send(.fetchHomeDataResponse(
                        Result { try await homeClient.getSectionList() }
                    ))
                }
                
//            case .refresh:
//                return .send(.searchResultsFeature(.submitSearch(state.searchText)))

            case let .fetchHomeDataResponse(.success(sections)):
                state.homeData = sections
                return .none
                
            case .fetchHomeDataResponse(.failure):
                // 处理错误情况
                return .none
                
                
            case .onLoginTapped:
                // 处理登录点击
                return .none
                
            case .toggleSearch:
                // 使用 .run 效果来添加动画
                return .run { [isSearchActive = state.isSearchActive] send in
                    await send(.binding(.set(\.isSearchActive, !isSearchActive)), animation: .spring)
                    
                    // 如果搜索状态被关闭，清空搜索文本和搜索结果
                    if isSearchActive {
                        await send(.binding(.set(\.searchText, "")))
                        await send(.binding(.set(\.isShowingSearchResults, false)))
                    }
                }
                
            case .binding(\.searchText):
                if state.searchText.isEmpty {
                    state.isShowingSearchResults = false
                }
                return .none
                
            case .submitSearch:
                // 如果搜索文本为空，不执行搜索
                guard !state.searchText.isEmpty else { return .none }
                
                // 添加到搜索历史
                if !state.searchHistoryString.toStringArray.contains(state.searchText) {
                    state.$searchHistoryString.withLock { $0 = $0.addToCommaSeparatedList(state.searchText) }
                    // 限制历史记录数量
                    if state.searchHistoryString.toStringArray.count > 10 {
                        state.$searchHistoryString.withLock { $0 = $0.limitCommaSeparatedItems(to: 10) }
                    }
                }
                
                // 显示搜索结果视图
                state.isShowingSearchResults = true
                
                // 委托给搜索结果组件执行搜索
                return .send(.searchResultsFeature(.submitSearch(.keyword(state.searchText))))
                
            case let .searchOverlay(.onSelectItem(text)):
                state.searchText = text
                return .send(.submitSearch)
     
                
            case let .onSectionTitleTapped(section):
                // 根据分区类型导航到不同页面
                if section.dataList?.first?.dataType == .cooperativeSchool {
                    // 如果是学校类型，导航到学校列表页面
                    state.path.append(.schoolList(SDSchoolListFeature.State(
                        sectionId: section.id,
                        sectionTitle: section.name ?? ""
                    )))
                } else if section.dataList?.first?.dataType == .textbook {
                    // 默认导航到图书列表页面
                    state.path.append(.bookList(SDBookListFeature.State(
                        sectionId: section.id,
                        sectionTitle: section.name ?? ""
                    )))
                }
                return .none
                
            case let .onSectionItemTapped(item):
                // 根据点击的项目类型进行不同处理
                switch item.dataType {
                case .textbook:
                    
                    state.path.append(.bookDetail(SDBookDetailReducer.State(id: item.id)))
                    
                    return .none
                case .cooperativeSchool:
                    let book = SDBookListFeature.State.init(sourceType: .school(item.id), sectionTitle: item.dataName ?? "大学")
                    state.path.append(.bookList(book))
                    return .none
                default:
                    print("点击了其他类型项目: \(item.dataName ?? "")")
                    return .none
                }
                
            case .path(.element(id: _, action: .test(.delegate(.nextPage(let page))))):
                state.path.append(.test(SDHomeTestFeature.State(page: page)))
                return .none
                
            case .path(.element(id: _, action: .test(.delegate(.pop)))):
                state.path.popLast()
                return .none
                
            case .path(.element(id: _, action: .test(.delegate(.popToRoot)))):
                state.path.removeAll()
                return .none
                
            
            
             
             case let .searchResultsFeature(.delegate(.bookSelected(book))):
                // 处理图书选择，跳转到详情页
                state.path.append(.bookDetail(SDBookDetailReducer.State(id: book.id)))
                return .none
                
            case .binding, .path, .searchOverlay, .searchResultsFeature:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}





