//
//  SDStudyTeacherBookListFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct SDStudyTeacherBookListFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared var isTop: Bool
        // 列表相关状态
        var isLoading = false
        var isLoadingMore: Bool = false
        var bookResults: SDTeacherBookPageResult? = nil
        var currentPagination: SDPagination = .default
        var canLoadMore: Bool = false
        
       
    }
    
    enum Action: BindableAction {
        // 绑定操作
        case binding(BindingAction<State>)
        
        // 列表相关操作
        case loadBooks
        case loadBooksResponse(Result<SDTeacherBookPageResult, Error>)
        case loadMoreBooks
        case loadMoreBooksResponse(Result<SDTeacherBookPageResult, Error>)
        
        // 委托给父组件的操作
        case delegate(Delegate)
        case view(View)
        enum View {
            case onAppear
            case addTeacherBook
            case toLesson
            case tapBookItem(SDStudyMyDbookDto)
        }
        enum Delegate {
            case bookSelected(SDStudyMyDbookDto)
        }
    }
    
    @Dependency(\.studyClient) var studyClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .loadBooks:
                state.isLoading = true
                state.bookResults = nil
                state.currentPagination = .default
                state.canLoadMore = false
                
                return .run { send in
                    await send(.loadBooksResponse(
                        Result {
                            try await studyClient.getTeacherBookPageList(.default)
                        }
                    ))
                }
                
            case let .loadBooksResponse(.success(items)):
                state.isLoading = false
                state.bookResults = items
                state.canLoadMore = items.hasMoreData
                return .none
                
            case .loadBooksResponse(.failure):
                state.isLoading = false
                return .none
                
            case .loadMoreBooks:
                if !state.canLoadMore {
                    state.isLoadingMore = false
                    return .none
                }
                
                state.isLoadingMore = true
                
                // 使用当前分页信息创建下一页
                let nextPagination = state.currentPagination.nextPage
                
                return .run { [pagination = nextPagination] send in
                    await send(.loadMoreBooksResponse(
                        Result {
                            try await studyClient.getTeacherBookPageList(pagination)
                        }
                    ))
                }
                
            case let .loadMoreBooksResponse(.success(newItems)):
                state.isLoadingMore = false
                
                // 更新分页信息
                state.currentPagination = state.currentPagination.nextPage
                var newItems = newItems
                
                newItems.rows = (state.bookResults?.rows ?? []) + (newItems.rows ?? [])
                state.bookResults = newItems
                state.canLoadMore = newItems.hasMoreData
                
                return .none
                
            case .loadMoreBooksResponse(.failure):
                state.isLoadingMore = false
                return .none
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            case .view(let action):
                switch action {
                    
                case .onAppear:
                    if state.bookResults == nil {
                        return .send(.loadBooks)
                    }
                    return .none
                case .addTeacherBook:
                    return .none

                case .toLesson:
                    return .none

                case .tapBookItem(_):
                    return .none

                }
            }
        }
    }
}


