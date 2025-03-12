import Foundation
import ComposableArchitecture
import Moya

/// 扩展依赖值以包含搜索客户端
extension DependencyValues {
    var searchClient: SDSearchClient {
        get { self[SDSearchClient.self] }
        set { self[SDSearchClient.self] = newValue }
    }
}

/// 搜索相关的客户端接口
struct SDSearchClient {
    /// 获取热门搜索词
    var getHotSearchKeys: @Sendable () async throws -> [String]
    
    /// 关键词搜索图书
    var searchBooks: @Sendable (_ params: SDReqParaKeywordSearch) async throws -> SDBookSearchResult
    
    /// 分类搜索图书
    var searchBooksByCategory: @Sendable (_ params: SDReqParaCategorySearch) async throws -> SDBookSearchResult
    
    /// 高级搜索图书
    var advancedSearchBooks: @Sendable (_ params: SDReqParaAdvancedSearch) async throws -> SDBookSearchResult
}

extension SDSearchClient: DependencyKey {
    /// 提供实际的搜索客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getHotSearchKeys: {
                let result: String = try await apiService.requestResult(SDSearchEndpoint.hotSearchKeys)
                return result.split(separator: ",").map { String($0) }
            },
            searchBooks: { params in
                try await apiService.requestResult(SDSearchEndpoint.searchBooks(params: params))
            },
            searchBooksByCategory: { params in
                try await apiService.requestResult(SDSearchEndpoint.searchBooksByCategory(params: params))
            },
            advancedSearchBooks: { params in
                try await apiService.requestResult(SDSearchEndpoint.advancedSearchBooks(params: params))
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getHotSearchKeys: {
                return ["信息技术", "少数345民族", "数44字", "三维12", "诗歌小史"]
            },
            searchBooks: { _ in
                return SDBookSearchResult.mock
            },
            searchBooksByCategory: { _ in
                return SDBookSearchResult.mock
            },
            advancedSearchBooks: { _ in
                return SDBookSearchResult.mock
            }
        )
    }
    
    static var previewValue: SDSearchClient {
        testValue
    }
}