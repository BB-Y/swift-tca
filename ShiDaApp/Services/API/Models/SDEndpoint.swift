import Foundation
import Moya

/// API 端点基础协议
public protocol SDEndpoint: TargetType {
    
    
    /// API 版本
    var version: String { get }
   
    
}

public extension SDEndpoint {
    var baseURL: URL {
        return APIConfiguration.baseURL
    }
    
    var headers: [String: String]? {
        var headers = APIConfiguration.defaultHeaders
        
      
        return headers
    }
   

    
    /// 默认版本
    var version: String {
        return "v1"
    }

}
