import Foundation
import Moya

/// API 端点基础协议
public protocol SDEndpoint: TargetType {
    /// API 版本
    var version: String { get }
    
    /// 是否需要认证
    var requiresAuth: Bool { get }
}

public extension SDEndpoint {
    var baseURL: URL {
        return APIConfiguration.baseURL
    }
    
    var headers: [String: String]? {
        var headers = APIConfiguration.defaultHeaders
        
        if requiresAuth {
            // TODO: 添加认证 token
            headers["Authorization"] = "Bearer <token>"
        }
        
        return headers
    }
    
    var path: String {
        return "/api/\(version)\(endpointPath)"
    }
    
    /// 端点路径
    var endpointPath: String {
        return "12"
        //fatalError("必须在具体的端点类型中实现此属性")
    }
    
    /// 默认版本
    var version: String {
        return "v1"
    }
    
    /// 默认不需要认证
    var requiresAuth: Bool {
        return false
    }
}
