import Foundation
import Moya

/// 搜索相关的 API 端点
enum SDSearchEndpoint {
    /// 获取热门搜索词
    case hotSearchKeys
    /// 根据关键词搜索图书
    case searchBooks(params: SDReqParaKeywordSearch)
    /// 根据分类搜索图书
    case searchBooksByCategory(params: SDReqParaCategorySearch)
    /// 高级搜索图书
    case advancedSearchBooks(params: SDReqParaAdvancedSearch)
}

extension SDSearchEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .hotSearchKeys:
            return "/app/dbook/hotsearchkey"
        case .searchBooks, .searchBooksByCategory, .advancedSearchBooks:
            return "/app/dbook/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .hotSearchKeys, .searchBooks, .searchBooksByCategory, .advancedSearchBooks:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .hotSearchKeys:
            return .requestPlain
            
        case let .searchBooks(params):
            return .requestParameters(
                parameters: [
                    "keyword": params.keyword,
                    "offset": params.pagination.offset,
                    "pageSize": params.pagination.pageSize
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .searchBooksByCategory(params):
            var parameters: [String: Any] = [
                "keyword": params.keyword,
                "offset": params.pagination.offset,
                "pageSize": params.pagination.pageSize,
                "sortType": params.sortType.rawValue
            ]
            
            if let categoryId = params.categoryId {
                parameters["categoryId"] = categoryId
            }
            
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
            
        case let .advancedSearchBooks(params):
            var parameters: [String: Any] = [
                "offset": params.pagination.offset,
                "pageSize": params.pagination.pageSize
            ]
            
            if let keyword = params.keyword { parameters["keyword"] = keyword }
            if let schoolId = params.schoolId { parameters["schoolId"] = schoolId }
            if let categoryId = params.categoryId { parameters["categoryId"] = categoryId }
            if let sortType = params.sortType { parameters["sortType"] = sortType }
            if let type = params.type { parameters["type"] = type }
            if let startTime = params.startTime { parameters["startTime"] = startTime }
            if let endTime = params.endTime { parameters["endTime"] = endTime }
            
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}
