import Foundation
import Moya

/// API 配置
public enum APIConfiguration {
    /// 基础 URL
    public static let baseURL = URL(string: "http://101.200.165.201:6005/")!
    
    /// 默认 headers
    public static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json, text/plain, */*",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8"
        ]
    }
    
    /// 默认插件
    public static var defaultPlugins: [PluginType] {
        return [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
    }
    
    /// 默认超时时间
    public static let timeoutInterval: TimeInterval = 30
}

/// API 错误
public enum APIError: LocalizedError {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(code: Int, message: String)
    case unauthorized
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .invalidResponse:
            return "无效的响应数据"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .serverError(_, let message):
            return message
        case .unauthorized:
            return "未授权的访问"
        }
    }
}
