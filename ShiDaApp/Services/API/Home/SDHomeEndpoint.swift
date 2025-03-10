import Foundation
import Moya

/// 首页相关的 API 端点
enum SDHomeEndpoint {
    /// 获取首页栏目列表
    case sectionList
}

extension SDHomeEndpoint: SDEndpoint {
    
    public var path: String {
        switch self {
        case .sectionList:      return "/app/homepage/sectionlist"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sectionList:      return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .sectionList:
            return .requestPlain
        }
    }
}