import Foundation
import CodableWrappers



protocol SDCodable: Codable {
    
    static func decode(from data: Data) -> Self

    static func decode(from json: String) -> Self
    var jsonString: String {get}
    var data: Data{get}

}


/// 通用 API 响应模型

public struct SDAPIResponse<T: Codable>: Codable {
    /// 状态码
    public let code: Int
    
    /// 消息
    
    public let msg: String
    
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
