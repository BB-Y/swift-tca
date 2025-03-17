//
//  SDSearchOverlayFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import ComposableArchitecture
import UIKit
@Reducer
struct SDSearchOverlayFeature {
    @ObservableState
    struct State: Equatable {
        var hotSearches: [String] = []
        var isLoading: Bool = false
        
        @Shared(.shareSearchHistory) var searchHistoryString = ""

        var searchHistory: [String] {
            searchHistoryString.split(separator: ",").map { String($0) }
        }
    }
    
    enum Action {
        // 外部动作
        case onAppear
        case clearSearchHistory
        case onSelectItem(String)
        
        // 内部动作
        case hotSearchesResponse(Result<[String], Error>)
    }
    
    @Dependency(\.searchClient) var searchClient
    @Dependency(\.continuousClock) var clock
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(.hotSearchesResponse(
                        Result { try await searchClient.getHotSearchKeys() }
                    ))
                }
                
            case let .hotSearchesResponse(.success(hotSearches)):
                state.isLoading = false
                state.hotSearches = hotSearches
                return .none
                
            case .hotSearchesResponse(.failure):
                state.isLoading = false
                // 可以在这里添加错误处理逻辑
                return .none
                
            case .clearSearchHistory:
                state.$searchHistoryString.withLock{$0 = ""}
                return .none
                
            case let .onSelectItem(text):
                // 如果需要，可以在这里添加搜索历史记录
                if !state.searchHistory.contains(text) {
                    state.$searchHistoryString.withLock { $0 = $0.addToCommaSeparatedList(text) }
                    // 限制历史记录数量
                    if state.searchHistory.count > 10 {
                        state.$searchHistoryString.withLock { $0 = $0.limitCommaSeparatedItems(to: 10) }
                    }
                }

                return .run { send in
                    try await clock.sleep(for: .seconds(0.2))
                    await UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                }
            }
        }
    }
}
