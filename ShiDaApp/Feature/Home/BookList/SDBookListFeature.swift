//
//  SDBookListFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDBookListFeature {
    
   
    
    @ObservableState
    struct State: Equatable {
        // 定义图书列表来源类型
        enum SourceType: Equatable {
            case section(_ sectionId: Int)
            case school(_ schoolId: Int)
        }
        // 来源类型
        let sourceType: SourceType
        // 栏目标题
        let sectionTitle: String
        // 图书列表数据
        var bookList: [SDResponseHomeSectionBook]?
        // 是否正在加载
        var isLoading: Bool = false
        // 是否出现错误
        var hasError: Bool = false
        // 搜索文本
        var searchText: String = ""
        // 搜索结果
        var searchResults: [SDResponseHomeSectionBook] = []
        // 是否正在搜索
        var isSearching: Bool = false
        
        // 兼容旧的初始化方式
        init(sectionId: Int, sectionTitle: String) {
            self.sourceType = .section(sectionId)
            self.sectionTitle = sectionTitle
        }
        
        // 新的初始化方式，支持学校来源
        init(sourceType: SourceType, sectionTitle: String) {
            self.sourceType = sourceType
            self.sectionTitle = sectionTitle
        }
    }
    
    enum Action: BindableAction {
        // 页面出现
        case onAppear
        // 获取图书列表响应
        case fetchBookListResponse(Result<[SDResponseHomeSectionBook], Error>)
        
        // 执行搜索
        case performSearch
        // 搜索文本绑定
        case binding(BindingAction<State>)
    }
    
    enum CancelID: Hashable {
        case fetchBookList
        case searchDebounce
    }
    
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                // 开始加载
                state.isLoading = true
                state.hasError = false
                
                // 根据来源类型请求不同的图书列表数据
                return .run { [sourceType = state.sourceType] send in
                    switch sourceType {
                    case .section(let sectionId):
                        await send(.fetchBookListResponse(
                            Result { try await homeClient.getSectionDetailBookList(sectionId) }
                        ))
                    case .school(let schoolId):
                        await send(.fetchBookListResponse(
                            Result { try await homeClient.getSchoolBookList(schoolId) }
                        ))
                    }
                }
                .cancellable(id: CancelID.fetchBookList)
                
            case let .fetchBookListResponse(.success(books)):
                // 更新图书列表数据
                state.bookList = books
                state.isLoading = false
                
                // 如果有搜索文本，立即执行搜索
                if !state.searchText.isEmpty {
                    return .send(.performSearch)
                }
                return .none
                
            case .fetchBookListResponse(.failure):
                // 处理错误情况
                state.isLoading = false
                state.hasError = true
                return .none
                
           
                
            case .performSearch:
                guard let books = state.bookList else {
                    state.searchResults = []
                    state.isSearching = false
                    return .none
                }
                
                state.isSearching = false
                
                if state.searchText.isEmpty {
                    state.searchResults = []
                    return .none
                }
                
                // 执行搜索
                state.searchResults = books.filter { book in
                    (book.name ?? "").localizedCaseInsensitiveContains(state.searchText)
                }
                
                return .none
                
            case .binding(\.searchText):
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
            }
        }
    }
}
