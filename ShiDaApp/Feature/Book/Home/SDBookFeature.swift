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
        
        // 二级分类数据
        var subCategories: [SDBookCategory] = []
        var isLoadingSubCategories: Bool = false
        var selectedSubCategoryId: Int? = nil
        
      
        var currentSortType: SDSearchSortType = .latest
        
        // 搜索相关状态
        var searchText = ""
        
        // 搜索结果组件状态
        var searchResultsFeature = SDSearchResultsFeature.State()
        
        // 导航状态
        var path: StackState<Path.State> = StackState<Path.State>()
        
        // 共享状态
        @Shared(.shareSearchHistory) var searchHistoryString = ""
        //
        var bookDetailFeature = SDBookDetailReducer.State(id: 0)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case bookDetail(SDBookDetailReducer)
        // 可能需要的其他导航目标
        case bookReader(SDBookReaderReducer)
    }
    
    enum Action: BindableAction {
        // 绑定操作
        case binding(BindingAction<State>)
        
        // 页面生命周期
        case onAppear
        case onLoginTapped

        // 分类相关
        case fetchCategoriesResponse(Result<[SDBookCategory], Error>)
        case selectCategory(Int?)
        case selectSubCategory(Int?)

        // 排序相关
        case changeSortType(SDSearchSortType)
        
        // 搜索相关操作
        //所有有关搜索的操作都使用这个 action
        case submitSearch
        case searchResultsFeature(SDSearchResultsFeature.Action)
        
        // 导航相关
        case path(StackActionOf<Path>)
        
        //  初始化页面时触发
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
                print("====\(categories)")
                return .none
                
            case .fetchCategoriesResponse(.failure):
                state.isLoadingCategories = false
                // 处理错误情况
                return .none
                
            case let .selectCategory(categoryId):
                // 如果点击的是已选中的分类，不做任何操作
                if state.selectedCategoryId == categoryId {
                    return .none
                }
                
                state.selectedCategoryId = categoryId
                state.selectedSubCategoryId = nil  // 重置二级分类选择
                
                // 如果选择了全部或没有选择分类，清空二级分类
                if categoryId == nil {
                    state.subCategories = []
                } else {
                    // 从已加载的一级分类中查找对应的二级分类
                    if let selectedCategory = state.categories.first(where: { $0.id == categoryId }),
                       var subList = selectedCategory.subList {
                        let all = SDBookCategory(createTime: "", id: nil, level: nil, name: "全部", parentId: nil, subList: nil)
                        subList.insert(all, at: 0)
                        state.subCategories = subList
                    } else {
                        state.subCategories = []
                    }
                }
                
                // 获取书籍列表
                return .send(.fetchBookList)
                
            case let .selectSubCategory(subCategoryId):
                // 如果点击的是已选中的二级分类，不做任何操作
                if state.selectedSubCategoryId == subCategoryId {
                    return .none
                }
                
                state.selectedSubCategoryId = subCategoryId
                return .send(.fetchBookList)
                
            case let .changeSortType(sortType):
                state.currentSortType = sortType
                // 这里可以添加根据排序方式重新获取书籍的逻辑
                return .send(.fetchBookList)
                
                
                
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
                return .send(.fetchBookList)
                
                
            case let .searchResultsFeature(.delegate(.bookSelected(book))):
                // 处理图书选择，跳转到详情页
                state.path.append(.bookDetail(SDBookDetailReducer.State(id: book.id)))
                return .none
            case .fetchBookList:
                // 创建搜索参数，考虑一级和二级分类
                let categoryId: Int?
                
                // 如果有选中的二级分类，优先使用二级分类ID
                if let subCategoryId = state.selectedSubCategoryId {
                    categoryId = subCategoryId
                } else {
                    categoryId = state.selectedCategoryId
                }
                
                // 委托给搜索结果组件执行搜索
                return .send(.searchResultsFeature(.submitSearch(.category(keyword: state.searchText, categoryId: categoryId, sortType: state.currentSortType))))
            case .path(.element(id: _, action: .bookDetail(.delegate(let action)))):
                switch action {
                
                case .navigateToTeacherApply:
                    return .none
                case .navigateToBuyPaperBook:
                    return .none
                
                case .navigateToChapterDetail(let bookDetail,let chapterId):
                    state.path.append(.bookReader(SDBookReaderReducer.State(id: bookDetail.id, chapterId: chapterId, bookDetail: bookDetail )))
                    return .none
                }
            case .path:
                return .none
            case .binding, .searchResultsFeature, .onLoginTapped:
                return .none
            
            }
        }
        .forEach(\.path, action: \.path)
    }
}
