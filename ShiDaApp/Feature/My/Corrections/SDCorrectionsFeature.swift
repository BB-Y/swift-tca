import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDCorrectionsFeature {
    
    @ObservableState
    struct State: Equatable {
        // 纠错列表数据
        var correctionList: [SDResponseCorrectionInfo]?
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
        
        case getCorrectionList
        // 获取纠错列表响应
        case fetchCorrectionsResponse(Result<SDCorrectionListResult, Error>)
        // 加载更多
        case loadMore
    }
    
    @Dependency(\.myClient) var myClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.correctionList != nil {
                    return .none
                }
                state.isLoading = true
                return .send(.getCorrectionList)
            case .getCorrectionList:
                state.currentPagination = .default
                return .run { send in
                    await send(.fetchCorrectionsResponse(
                        Result { try await myClient.getCorrectionList(.default) }
                    ))
                }
            case let .fetchCorrectionsResponse(.success(result)):
                
                if state.isLoadingMore {
                    if let newItems = result.rows {
                        state.correctionList?.append(contentsOf: newItems)
                    }
                    state.currentPagination = state.currentPagination.nextPage
                    state.isLoadingMore = false
                } else {
                    state.correctionList = result.rows
                    state.isLoading = false
                    state.hasError = false
                }
                state.canLoadMore = result.hasMoreData

                
                return .none
                
            case .fetchCorrectionsResponse(.failure):
                state.isLoading = false
                state.isLoadingMore = false
                state.hasError = true
                return .none
                
            case .loadMore:
                guard !state.isLoadingMore && state.canLoadMore else { return .none }
                
                state.isLoadingMore = true
                let nextPage = state.currentPagination.nextPage
                
                return .run {send in
                    await send(.fetchCorrectionsResponse(
                        Result { try await myClient.getCorrectionList(nextPage) }
                    ))
                }
            }
        }
    }
}
