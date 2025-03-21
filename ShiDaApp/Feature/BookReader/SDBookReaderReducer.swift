//
//  SDBookReaderReducer.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDBookReaderReducer {
    @ObservableState
    struct State: Equatable {
        let id: Int
        let chapterId : Int
        // 图书详情状态
        var isLoading: Bool = false
        var bookDetail: SDBookDetailModel? = nil
        
        var chapterArray : [SDChapterDetailModel] = []
        var errorMessage: String? = nil
        
        func getChapterContent() -> String {
            for cell in chapterArray {
                if cell.id == chapterId
                {
                    return cell.content ?? ""
                }
            }
            
            return ""
        }
    }
    
    enum Action: ViewAction, BindableAction {
        
        case binding(BindingAction<State>)
        case view(View)
        
        // 内部 Action
        case fetchChapterDetail
        case chapterDetailResponse(Result<SDChapterDetailModel, Error>)
        
        // 导航相关 - 由父级 reducer 处理
        case delegate(Delegate)
        enum Delegate {
            case navigateToChapterDetail(Int)
        }
    }
    enum View {
        case onAppear
        case onBackTapped

    }
    
    @Dependency(\.bookReaderClient) var bookReaderClient
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    if state.bookDetail != nil {
                        return .none
                    }
                    return .send(.fetchChapterDetail)
                case .onBackTapped:
                    return .run { _ in
                        await dismiss()
                    }
                }
            case .delegate, .binding:
                    // 这些 action 会被父级 reducer 处理
                return .none
            case .fetchChapterDetail:
                state.isLoading = true
                return .run { [id = state.chapterId] send in
                    await send(.chapterDetailResponse(
                        Result {
                            try await bookReaderClient.fetchChapterDetail(id)
                        }
                    ))
            }
            case let .chapterDetailResponse(.success(detail)):
                state.isLoading = false
                var bAdd = true
                for cell in state.chapterArray {
                    if cell.id == detail.id
                    {
                        bAdd = false;
                        break;
                    }
                }
                if bAdd {
                    state.chapterArray.append(detail)
                }
                return .none
                
            case let .chapterDetailResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
    
}
