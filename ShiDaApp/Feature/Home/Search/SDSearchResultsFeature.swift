//
//  SDSearchResultsFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SDSearchResultsFeature {
    
    @ObservableState
    struct State: Equatable {
        // 搜索相关状态
        var isSearchLoading = false
        var isLoadingMore: Bool = false
        var searchResults: SDBookSearchResult? = nil
        var currentPagination: SDPagination = .default
        var canLoadMore: Bool = false
        
        // 搜索类型
        var searchType: SearchType = .keyword("")
    }
    
    // 搜索类型枚举
    enum SearchType: Equatable {
        case keyword(String)
        case category(keyword: String, categoryId: Int?, sortType: SDSearchSortType)
        
        var isEmpty: Bool {
            switch self {
            case .keyword(let keyword):
                return keyword.isEmpty
            case .category(let keyword, _, _):
                return keyword.isEmpty
            }
        }
    }
    
    enum Action: BindableAction {
        // 绑定操作
        case binding(BindingAction<State>)
        
        // 搜索相关操作
        case submitSearch(SearchType)
        case searchResponse(Result<SDBookSearchResult, Error>)
        case loadMoreSearch
        case loadMoreSearchResponse(Result<SDBookSearchResult, Error>)
        
        // 委托给父组件的操作
        case delegate(Delegate)
        
        enum Delegate {
            case bookSelected(SDResponseBookInfo)
        }
    }
    
    @Dependency(\.searchClient) var searchClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .submitSearch(searchType):
                
                state.searchType = searchType
                state.isSearchLoading = true
                state.searchResults = nil
                state.currentPagination = .default
                state.canLoadMore = false
                
                switch searchType {
                case .keyword(let keyword):
                    return .run { send in
                        await send(.searchResponse(
                            Result {
                                try await searchClient.searchBooks(
                                    SDReqParaKeywordSearch.default(keyword: keyword)
                                )
                            }
                        ))
                    }
                    
                case .category(let keyword, let categoryId, let sortType):
                    return .run { send in
                        await send(.searchResponse(
                            Result {
                                try await searchClient.searchBooksByCategory(
                                    SDReqParaCategorySearch(
                                        keyword: keyword,
                                        categoryId: categoryId,
                                        sortType: sortType,
                                        pagination: .default
                                    )
                                )
                            }
                        ))
                    }
                }
                
            case let .searchResponse(.success(items)):
                state.isSearchLoading = false
                state.searchResults = items
                
                state.canLoadMore = items.hasMoreData

                
                
                return .none
                
            case .searchResponse(.failure):
                state.isSearchLoading = false
                return .none
                
            case .loadMoreSearch:
                if !state.canLoadMore {
                    state.isLoadingMore = false

                    return .none
                }
                print("loadmore")
                state.isLoadingMore = true
                
                // 使用当前分页信息创建下一页
                let nextPagination = state.currentPagination.nextPage
                
                switch state.searchType {
                case .keyword(let keyword):
                    return .run { [pagination = nextPagination] send in
                        await send(.loadMoreSearchResponse(
                            Result {
                                let params = SDReqParaKeywordSearch(
                                    keyword: keyword,
                                    pagination: pagination
                                )
                                return try await searchClient.searchBooks(params)
                            }
                        ))
                    }
                    
                case .category(let keyword, let categoryId, let sortType):
                    return .run { [pagination = nextPagination] send in
                        await send(.loadMoreSearchResponse(
                            Result {
                                let params = SDReqParaCategorySearch(
                                    keyword: keyword,
                                    categoryId: categoryId,
                                    sortType: sortType,
                                    pagination: pagination
                                )
                                return try await searchClient.searchBooksByCategory(params)
                            }
                        ))
                    }
                }
                
            case let .loadMoreSearchResponse(.success(newItems)):
                state.isLoadingMore = false
                
                // 更新分页信息
                state.currentPagination = state.currentPagination.nextPage
                
                // 合并搜索结果
                if var currentResults = state.searchResults {
                    currentResults.rows = (currentResults.rows ?? []) + (newItems.rows ?? [])
                    state.searchResults = currentResults
                    state.canLoadMore = newItems.hasMoreData

                }
                
                return .none
                
            case .loadMoreSearchResponse(.failure):
                state.isLoadingMore = false
                return .none
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
