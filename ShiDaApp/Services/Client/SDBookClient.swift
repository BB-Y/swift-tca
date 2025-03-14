import Foundation
import ComposableArchitecture
import Moya

/// 扩展依赖值以包含图书客户端
extension DependencyValues {
    var bookClient: SDBookClient {
        get { self[SDBookClient.self] }
        set { self[SDBookClient.self] = newValue }
    }
}

/// 图书相关的客户端接口
struct SDBookClient {
    /// 获取图书分类标签列表
    var getBookCategories: @Sendable () async throws -> [SDBookCategory]
    
    /// 获取图书详情
    var fetchBookDetail: @Sendable (Int) async throws -> SDBookDetailModel
    
    /// 收藏/取消收藏图书
    var toggleFavorite: @Sendable (Int, Bool) async throws -> Bool
}

extension SDBookClient: DependencyKey {
    /// 提供实际的图书客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getBookCategories: {
                try await apiService.requestResult(SDBookEndpoint.bookCategories)
            },
            
            fetchBookDetail: { id in
                try await apiService.requestResult(SDBookEndpoint.bookDetail(id: id))
            },
            
            toggleFavorite: { bookId, isFavorite in
                // 发送请求并返回最新的收藏状态
                try await apiService.requestResult(SDBookEndpoint.toggleFavorite(bookId: bookId, isFavorite: isFavorite))
                 // 假设API成功后状态与请求一致
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getBookCategories: {
                return SDBookCategory.mockArray
            },
            
            fetchBookDetail: { _ in
                return SDBookDetailModel.mock
            },
            
            toggleFavorite: { _, isFavorite in
                // 模拟环境直接返回请求的状态
                return isFavorite
            }
        )
    }
    
    static var previewValue: SDBookClient {
        testValue
    }
}
