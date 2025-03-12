//
//  SDBookFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/12.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SDBookFeature: Reducer {
    
    @ObservableState
    struct State: Equatable {
        // 书籍分类数据
        var categories: [SDBookCategory] = []
        var isLoadingCategories: Bool = false
        
        // 当前选中的分类
        var selectedCategoryId: Int? = nil
        
        // 排序方式
        enum SortType: String, Equatable, CaseIterable {
            case newest = "最新"
            case hottest = "最热"
        }
        var currentSortType: SortType = .newest
        
        // 搜索相关状态
        var searchText = ""
        
        
        // 搜索结果组件状态
        var searchResultsFeature = SDSearchResultsFeature.State()
        
        // 导航状态
        var path: StackState<Path.State> = StackState<Path.State>()
        
        // 共享状态
        @Shared(.shareSearchHistory) var searchHistoryString = ""
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case bookDetail(SDBookDetailReducer)
        // 可能需要的其他导航目标
    }
    
    enum Action: BindableAction {
        // 绑定操作
        case binding(BindingAction<State>)
        
        // 页面生命周期
        case onAppear
        
        // 分类相关
        case fetchCategoriesResponse(Result<[SDBookCategory], Error>)
        case selectCategory(Int?)
        
        // 排序相关
        case changeSortType(State.SortType)
        
        // 搜索相关操作
        case submitSearch
        case searchResultsFeature(SDSearchResultsFeature.Action)
        
        // 导航相关
        case path(StackActionOf<Path>)
        
        // 添加获取书籍列表的操作
        case fetchBookList
    }
    
    @Dependency(\.bookClient) var bookClient
    @Dependency(\.searchClient) var searchClient
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
    
        Scope(state: \.searchResultsFeature, action: \.searchResultsFeature) {
            SDSearchResultsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 页面出现时加载分类数据和书籍列表
                state.isLoadingCategories = true
                return .run { send in
                    await send(.fetchCategoriesResponse(
                        Result { try await bookClient.getBookCategories() }
                    ))
                    // 加载完分类后获取书籍列表
                    await send(.fetchBookList)
                }
                
            case let .fetchCategoriesResponse(.success(categories)):
                state.isLoadingCategories = false
                state.categories = categories
                return .none
                
            case .fetchCategoriesResponse(.failure):
                state.isLoadingCategories = false
                // 处理错误情况
                return .none
                
            case let .selectCategory(categoryId):
                state.selectedCategoryId = categoryId
                // 这里可以添加根据分类获取书籍的逻辑
                return .none
                
            case let .changeSortType(sortType):
                state.currentSortType = sortType
                // 这里可以添加根据排序方式重新获取书籍的逻辑
                return .none
                
       
                
            case .binding(\.searchText):
                
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
                
                // 委托给搜索结果组件执行搜索
                return .send(.searchResultsFeature(.submitSearch(.keyword(state.searchText))))
          
                
            case let .searchResultsFeature(.delegate(.bookSelected(book))):
                // 处理图书选择，跳转到详情页
                state.path.append(.bookDetail(SDBookDetailReducer.State(id: book.id)))
                return .none
                
           
            case .fetchBookList:
                // 创建搜索参数
                
                // 委托给搜索结果组件执行搜索
                return .send(.searchResultsFeature(.submitSearch(.keyword(state.searchText))))
                
            case .binding, .path, .searchResultsFeature:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
