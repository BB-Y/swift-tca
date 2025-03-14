import Foundation
import Moya

/// 图书相关的 API 端点
enum SDBookEndpoint {
    /// 获取图书分类标签列表
    case bookCategories
    /// 获取图书详情
    case bookDetail(id: Int)
    /// 收藏/取消收藏图书
    case toggleFavorite(bookId: Int, isFavorite: Bool)
}

extension SDBookEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .bookCategories:
            return "/app/dbook/category/list"
        case let .bookDetail(id):
            return "app/dbook/\(id)"
        case .toggleFavorite:
            return "/app/dbook/collection/commit"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .bookCategories, .bookDetail:
            return .get
        case .toggleFavorite:
            return .put
        }
    }
    
    public var task: Task {
        switch self {
        case .bookCategories:
            return .requestPlain
        case .bookDetail:
            // 由于ID已经包含在路径中，这里不需要查询参数
            return .requestPlain
        case let .toggleFavorite(bookId, isFavorite):
            // 将布尔值转换为后端需要的状态码：10表示收藏，20表示取消收藏
            let status = isFavorite ? 10 : 20
            let parameters: [String: Any] = [
                "bookId": bookId,
                "status": status
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
