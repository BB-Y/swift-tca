//
//  SDFavoritesFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/20.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDFavoritesFeature {
    
    @ObservableState
    struct State: Equatable {
        // 图书列表数据
        var bookList: [SDResponseBookInfo]?
        // 是否正在加载
        var isLoading: Bool = false
        // 是否出现错误
        var hasError: Bool = false
        // 搜索文本
        var searchText: String = ""
        // 搜索结果
        var searchResults: [SDResponseBookInfo] = []
        // 是否正在搜索
        var isSearching: Bool = false
        
        // 分页相关状态
        var isLoadingMore: Bool = false
        var currentPagination: SDPagination = .default
        var canLoadMore: Bool = false
    }
    
    enum Action: BindableAction {
        // 页面出现
        case onAppear
        
        
        // 获取收藏列表响应
        case fetchFavoritesResponse(Result<SDBookSearchResult, Error>)
        
        // 执行搜索
        case performSearch
        // 搜索文本绑定
        case binding(BindingAction<State>)
        
        // 加载更多
        case loadMoreFavorites
        case loadMoreFavoritesResponse(Result<SDBookSearchResult, Error>)
    }
    
    enum CancelID: Hashable {
        case fetchFavorites
        case searchDebounce
        case loadMoreFavorites
    }
    
    
    @Dependency(\.myClient) var myClient
    @Dependency(\.continuousClock) var clock
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                // 开始加载
                //state.isLoading = true
                state.hasError = false
                state.currentPagination = .default
                state.canLoadMore = false
                
                let SDReqParaMyCollection = SDReqParaMyCollection.init(
                    searchkey: state.searchText,
                    pagination: state.currentPagination
                )
                return .send(.performSearch)
                // 请求收藏列表数据
                return .run { send in
                    await send(.fetchFavoritesResponse(
                        Result { try await myClient.getFavoritesList(SDReqParaMyCollection) }
                    ))
                }
                .cancellable(id: CancelID.fetchFavorites)
                
            case let .fetchFavoritesResponse(.success(books)):
                // 更新图书列表数据
                state.bookList = books.rows
                //state.isLoading = false
                state.canLoadMore = books.hasMoreData
                
                // 如果有搜索文本，立即执行搜索
//                if !state.searchText.isEmpty {
//                    return .send(.performSearch)
//                }

                return .run {send in
                    await send(.binding(.set(\.isLoading, false)), animation: .spring)

                }
                
            case .fetchFavoritesResponse(.failure):
                // 处理错误情况
                //state.isLoading = false
                state.hasError = true
                return .none
                
            case .performSearch:
                let SDReqParaMyCollection = SDReqParaMyCollection.init(
                    searchkey: state.searchText,
                    pagination: SDPagination.default
                )
    
                // 请求收藏列表数据
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.fetchFavoritesResponse(
                        Result { try await myClient.getFavoritesList(SDReqParaMyCollection) }
                    ))
                }
                .cancellable(id: CancelID.fetchFavorites)
//                guard let books = state.bookList else {
//                    state.searchResults = []
//                    state.isSearching = false
//                    return .none
//                }
//                
//                state.isSearching = false
//                
//                if state.searchText.isEmpty {
//                    state.searchResults = []
//                    return .none
//                }
//                
//                // 执行搜索
//                state.searchResults = books.filter { book in
//                    (book.name ?? "").localizedCaseInsensitiveContains(state.searchText)
//                }
//                
//                return .none
                
            case .binding(\.searchText):
                return .none
                // 当搜索文本变化时，设置正在搜索状态
                state.isSearching = true
                
                // 使用节流来延迟搜索，避免频繁搜索
                return .run { send in
                    try await Task.sleep(for: .milliseconds(300))
                    await send(.performSearch)
                }
                .cancellable(id: CancelID.searchDebounce)
                
            case .binding(_):
                return .none
            case .loadMoreFavorites:
                if !state.canLoadMore || state.isLoadingMore {
                    return .none
                }
                
                state.isLoadingMore = true
                
                // 使用当前分页信息创建下一页
                let nextPagination = state.currentPagination.nextPage
                
                let SDReqParaMyCollection = SDReqParaMyCollection.init(
                    searchkey: state.searchText,
                    pagination: nextPagination
                )
                
                return .run { send in
                    await send(.loadMoreFavoritesResponse(
                        Result { try await myClient.getFavoritesList(SDReqParaMyCollection) }
                    ))
                }
                .cancellable(id: CancelID.loadMoreFavorites)
                
            case let .loadMoreFavoritesResponse(.success(newBooks)):
                state.isLoadingMore = false
                
                // 更新分页信息
                state.currentPagination = state.currentPagination.nextPage
                
                // 合并收藏列表结果
                if let currentBooks = state.bookList {
                    state.bookList = currentBooks + (newBooks.rows ?? [])
                } else {
                    state.bookList = newBooks.rows
                }
                
                state.canLoadMore = newBooks.hasMoreData
                
                // 如果正在搜索，更新搜索结果
                if !state.searchText.isEmpty {
                    return .send(.performSearch)
                }
                
                return .none
                
            case .loadMoreFavoritesResponse(.failure):
                state.isLoadingMore = false
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
