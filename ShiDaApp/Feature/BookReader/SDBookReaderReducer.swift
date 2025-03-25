//
//  SDBookReaderReducer.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//
import SwiftUI
import ComposableArchitecture

struct SDCatalogSearch {
    var bFind : Bool = false
    var bFindCatalogId: Int = 0
}
@Reducer
struct SDBookReaderReducer {
    @ObservableState
    struct State: Equatable {
        let id: Int
        var catalogId : Int
        // 图书详情状态
        var isLoading: Bool = false
        var bookDetail: SDBookDetailModel? = nil
        //var chapterArray : [SDChapterDetailModel] = []
        var errorMessage: String? = nil
        var pageConent : [SDChapterDetailModel] = []
        var bTurnPageNext : Bool = true
        
        
        //获取下一个目录节点的ID，根据章节ID 判断 一样的章节ID 要跳过
        mutating func getNextMainCatalogId(catalogId : Int) -> Int
        {
            var nextCatalogId = catalogId
            let oldM = getChapterContent(catalogId: nextCatalogId)
            var m : SDChapterDetailModel?
            while(true && oldM != nil )
            {
                nextCatalogId = getNextCatalogId(catalogId: nextCatalogId)
                if nextCatalogId == -1
                {
                    break
                }
                m = getChapterContent(catalogId: nextCatalogId)
                if m != nil {
                    if oldM!.id != m!.id
                    {
                        break
                    }
                }else
                {
                    break
                }
            }
            
            return nextCatalogId
        }
        //获取上一个目录节点的ID，根据章节ID 判断 一样的章节ID 要跳过
        mutating func getPreMainCatalogId(catalogId : Int) -> Int
        {
            var nextCatalogId = catalogId
            let oldM = getChapterContent(catalogId: nextCatalogId)
            var m : SDChapterDetailModel?
            while(true && oldM != nil )
            {
                nextCatalogId = getPreCatalogId(catalogId: nextCatalogId)
                if nextCatalogId == -1
                {
                    break
                }
                m = getChapterContent(catalogId: nextCatalogId)
                if m != nil {
                    if oldM!.id != m!.id
                    {
                        break
                    }
                }else
                {
                    break
                }
            }
            
            return nextCatalogId
        }
        mutating func getChapterContent(catalogId : Int) -> SDChapterDetailModel? {
            let articelId = getArticleId(inCatalogId: catalogId)
            for cell in pageConent {
                if cell.id == articelId
                {
                    return cell
                }
            }
            
            return nil
        }
        func isFirstChapter(catalogId : Int ) -> Bool
        {
            if bookDetail == nil || bookDetail!.catalogList == nil
            {
                return false
            }
        
            return bookDetail!.catalogList![0].id == catalogId
        }
        
        mutating func getNextCatalogId(catalogId : Int) -> Int
        {
            var nextId =  -1
            if bookDetail == nil || bookDetail!.catalogList == nil
            {
                return -1
            }
            var bOk = false
            for cell in bookDetail!.catalogList!
            {
                if bOk
                {
                    nextId = cell.id ?? -1
                    break
                }
                if cell.id == catalogId {
                    bOk = true
                }
                if cell.childs != nil {
                    if bOk
                    {
                        nextId = cell.childs![0].id ?? -1
                        break
                    }
                    nextId = getNextChildCatalogId(arrays: cell.childs!, catalogId: catalogId)
                    if nextId == 0
                    {
                        bOk = true
                        nextId = -1
                    }
                    if nextId != -1
                    {
                        break
                    }
                }
            }
            
            return nextId
        }
        mutating  func getNextChildCatalogId(arrays:[SDBookChapter], catalogId : Int) -> Int
        {
            var nextId = -1
            var bOk = false
            for cell in arrays
            {
                if bOk
                {
                    nextId = cell.id ?? -1
                    break
                }
                if cell.id == catalogId {
                    bOk = true
                    
                }
                if cell.childs != nil {
                    if bOk
                    {
                        nextId = cell.childs![0].id ?? -1
                        break
                    }
                    nextId = getNextChildCatalogId(arrays: cell.childs!,catalogId : catalogId)
                    if nextId == 0
                    {
                        bOk = true
                        nextId = -1
                    }
                    if nextId != -1
                    {
                        break
                    }
                }
            }
            if nextId == -1 && bOk
            {
                return 0
            }
            return nextId
        }
        
        mutating func getPreCatalogId(catalogId : Int) -> Int
        {
            var nextId =  -1
            if bookDetail == nil || bookDetail!.catalogList == nil
            {
                return -1
            }
            var bOk = false
            for cell in bookDetail!.catalogList!.reversed()
            {
                if cell.childs != nil {
                    if bOk
                    {
                        nextId = cell.childs![cell.childs!.count - 1].id ?? -1
                        break
                    }
                    nextId = getPreChildCatalogId(arrays: cell.childs!, catalogId: catalogId)
                    if nextId == 0
                    {
                        bOk = true
                        nextId = -1
                    }
                    if nextId != -1
                    {
                        break
                    }
                }
                
                if bOk
                {
                    nextId = cell.id ?? -1
                    break
                }
                if cell.id == catalogId {
                    bOk = true
                }
                
            }
            
            return nextId
        }
        
        mutating  func getPreChildCatalogId(arrays:[SDBookChapter], catalogId : Int) -> Int
        {
            var nextId = -1
            var bOk = false
            for cell in arrays.reversed()
            {
               
                if cell.childs != nil {
                    if bOk
                    {
                        nextId = cell.childs![cell.childs!.count - 1].id ?? -1
                        break
                    }
                    nextId = getPreChildCatalogId(arrays: cell.childs!,catalogId : catalogId)
                    if nextId == 0
                    {
                        bOk = true
                        nextId = -1
                    }
                    if nextId != -1
                    {
                        break
                    }
                }
                if bOk
                {
                    nextId = cell.id ?? -1
                    break
                }
                if cell.id == catalogId {
                    bOk = true
                    
                }
            }
            if nextId == -1 && bOk
            {
                return 0
            }
            return nextId
        }
        
        mutating func addPageContent(data : SDChapterDetailModel)
        {
            //需要判断从前面插入  还是从后面
            if bTurnPageNext {
                pageConent.append(data)
//                if pageConent.count > 3
//                {
//                    pageConent.remove(at: 0)
//                }
            }else
            {
                pageConent.insert(data, at: 0)
//                if pageConent.count > 3
//                {
//                    pageConent.remove(at: 3)
//                }
            }
        }
        mutating func getArticle(catalogId: Int) -> SDChapterDetailModel? {
            let currentArticleId = getArticleId(inCatalogId: catalogId)
            for cell in pageConent {
                if cell.id == currentArticleId
                {
                    return cell
                }
            }
            
            return nil
        }
       
        
        mutating func getArticleId(inCatalogId : Int) -> Int
        {
            if bookDetail == nil || bookDetail!.catalogList == nil
            {
                return -1
            }
            var currentArticleId = -1
            for cell in bookDetail!.catalogList!
            {
                if cell.id == inCatalogId {
                    currentArticleId = cell.linkArticleId ?? -1
                    break
                }
                if cell.childs != nil {
                    currentArticleId = getChildArticleId(arrays: cell.childs!, inCatalogId: inCatalogId)
                    if currentArticleId != -1
                    {
                        break
                    }
                }
            }
            
            return currentArticleId
        }
        func getChildArticleId(arrays:[SDBookChapter],inCatalogId: Int) -> Int
        {
            var currentArticleId = -1
            for cell in arrays
            {
                if cell.id == inCatalogId {
                    currentArticleId = cell.linkArticleId ?? -1
                    break
                }
                if cell.childs != nil {
                    currentArticleId = getChildArticleId(arrays: cell.childs!,inCatalogId: inCatalogId)
                    if currentArticleId != -1
                    {
                        break
                    }
                }
            }
            
            return currentArticleId
        }
    }
    
    enum Action: ViewAction, BindableAction {
        
        case binding(BindingAction<State>)
        case view(View)
        
        // 内部 Action
        case fetchChapterDetail(Int)
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
                    if state.bookDetail == nil {
                        return .none
                    }
                    return .send(.fetchChapterDetail(state.catalogId))
                case .onBackTapped:
                    return .run { _ in
                        await dismiss()
                    }
            }
            case .delegate, .binding:
                    // 这些 action 会被父级 reducer 处理
                return .none
            case let .fetchChapterDetail(catalogId):
                //state.isLoading = true
                
                let article = state.getArticle(catalogId: catalogId)
                if article != nil
                {
                    state.addPageContent(data: article!)
                    return .none
                }
                
                return .run { [id = state.getArticleId(inCatalogId: catalogId)] send in
                    await send(.chapterDetailResponse(
                        Result {
                            try await bookReaderClient.fetchChapterDetail(id)
                        }
                    ))
            }
            case let .chapterDetailResponse(.success(detail)):
                state.isLoading = false
                var bAdd = true
                for cell in state.pageConent {
                    if cell.id == detail.id
                    {
                        bAdd = false;
                        break;
                    }
                }
                if bAdd {
                    state.pageConent.append(detail)
                }
                //state.addPageContent(data: detail)
                
                if state.pageConent.count < 3
                {
                    let preId = state.getPreMainCatalogId(catalogId: state.catalogId)
                    let nextId = state.getNextMainCatalogId(catalogId: state.catalogId)
                    if preId != -1
                    {
                        if state.getArticleId(inCatalogId: preId) != detail.id
                        {
                            state.bTurnPageNext = false
                            return .run { [id = state.getArticleId(inCatalogId: preId)] send in
                                await send(.chapterDetailResponse(
                                    Result {
                                        try await bookReaderClient.fetchChapterDetail(id)
                                    }
                                ))
                            }
                        }
                    }else if nextId != -1
                    {
                        state.bTurnPageNext = true
                        if state.getArticleId(inCatalogId: nextId) != detail.id
                        {
                            return .run { [id = state.getArticleId(inCatalogId: nextId)] send in
                                await send(.chapterDetailResponse(
                                    Result {
                                        try await bookReaderClient.fetchChapterDetail(id)
                                    }
                                ))
                            }
                        }
                    }
                }
                
                return .none
                
            case let .chapterDetailResponse(.failure(error)):
                state.isLoading = false
                //state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
    
}
