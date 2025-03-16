import Foundation
import Moya

/// 华为云OBS相关的 API 端点
enum SDHuaweiCloudEndpoint {
    /// 获取华为云OBS密钥
    case getOBSAccessKey
}

extension SDHuaweiCloudEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .getOBSAccessKey:
            return "/common/huaweicloud/obsAk"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getOBSAccessKey:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getOBSAccessKey:
            return .requestPlain
        }
    }
}