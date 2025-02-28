import Foundation
import CodableWrappers

/// 通用 API 响应模型
@CustomCodable @SnakeCase
public struct SDAPIResponse<T: Codable>: Codable {
    /// 状态码
    public let code: Int
    
    /// 消息
    @CustomCodingKey("msg")
    public let message: String
    
    /// 数据
    public let data: T?
    
    public let status: Bool
    /// 是否成功
    public var isSuccess: Bool {
        return code == 200
    }
   
}

///// 分页响应模型
//public struct SDPaginatedResponse<T: Codable>: Codable {
//    /// 当前页码
//    public let page: Int
//    
//    /// 每页数量
//    public let pageSize: Int
//    
//    /// 总数量
//    public let total: Int
//    
//    /// 数据列表
//    public let items: [T]
//    
//    private enum CodingKeys: String, CodingKey {
//        case page
//        case pageSize = "page_size"
//        case total
//        case items
//    }
//}
