import Foundation
import Moya

/// 图书相关的 API 端点
enum SDBookEndpoint {
    /// 获取图书分类标签列表
    case bookCategories
}

extension SDBookEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .bookCategories:
            return "/app/dbook/category/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .bookCategories:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .bookCategories:
            return .requestPlain
        }
    }
}