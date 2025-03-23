import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDMessagesFeature {
    
    @ObservableState
    struct State: Equatable {
        // 消息列表数据
        var messageList: [SDMessageItem]?
        // 是否正在加载
        var isLoading: Bool = false
        // 是否出现错误
        var hasError: Bool = false
        
        // 分页相关状态
        var isLoadingMore: Bool = false
        var currentPagination: SDPagination = .default
        var canLoadMore: Bool = false
    }
    
    enum Action {
        // 页面出现
        case onAppear
        
        case getMessageList
        // 获取消息列表响应
        case fetchMessagesResponse(Result<SDMessageListResult, Error>)
        // 加载更多
        case loadMore
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.messageList != nil {
                    return .none
                }
                state.isLoading = true
                return .send(.getMessageList)
                
            case .getMessageList:
                state.currentPagination = .default
                return .run { send in
                    await send(.fetchMessagesResponse(
                        Result { try await userClient.getMyMessages(.default) }
                    ))
                }
                
            case let .fetchMessagesResponse(.success(result)):
                if state.isLoadingMore {
                    if let newItems = result.rows {
                        state.messageList?.append(contentsOf: newItems)
                    }
                    state.currentPagination = state.currentPagination.nextPage
                    state.isLoadingMore = false
                } else {
                    state.messageList = result.rows
                    state.isLoading = false
                    state.hasError = false
                }
                state.canLoadMore = result.hasMoreData
                return .none
                
            case .fetchMessagesResponse(.failure):
                state.isLoading = false
                state.isLoadingMore = false
                state.hasError = true
                return .none
                
            case .loadMore:
                guard !state.isLoadingMore && state.canLoadMore else { return .none }
                
                state.isLoadingMore = true
                let nextPage = state.currentPagination.nextPage
                
                return .run { send in
                    await send(.fetchMessagesResponse(
                        Result { try await userClient.getMyMessages(nextPage) }
                    ))
                }
            }
        }
    }
}