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
}

extension SDBookClient: DependencyKey {
    /// 提供实际的图书客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getBookCategories: {
                try await apiService.requestResult(SDBookEndpoint.bookCategories)
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getBookCategories: {
                return SDBookCategory.mockArray
            }
        )
    }
    
    static var previewValue: SDBookClient {
        testValue
    }
}