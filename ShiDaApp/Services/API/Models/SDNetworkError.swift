import Foundation

/// 网络错误类型
public enum SDNetworkError: LocalizedError {
    /// 网络连接错误
    case connectionError(Error)
    /// 请求超时
    case timeout
    /// 服务器错误
    case serverError(code: Int, message: String)
    /// 数据解析错误
    case decodingError(Error)
    /// 无效的请求
    case invalidRequest
    /// 认证失败
    case authenticationFailed
    /// 无网络连接
    case noInternetConnection
    /// 请求被取消
    case cancelled
    /// 未知错误
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .connectionError(let error):
            return "网络连接错误: \(error.localizedDescription)"
        case .timeout:
            return "请求超时"
        case .serverError(_, let message):
            return "服务器错误: \(message)"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .invalidRequest:
            return "无效的请求"
        case .authenticationFailed:
            return "认证失败"
        case .noInternetConnection:
            return "无网络连接"
        case .cancelled:
            return "请求已取消"
        case .unknown(let error):
            return "未知错误: \(error.localizedDescription)"
        }
    }
    
    /// 错误代码
    public var errorCode: Int {
        switch self {
        case .connectionError(_):
            return -1001
        case .timeout:
            return -1002
        case .serverError(let code, _):
            return code
        case .decodingError(_):
            return -1003
        case .invalidRequest:
            return -1004
        case .authenticationFailed:
            return 401
        case .noInternetConnection:
            return -1009
        case .cancelled:
            return -999
        case .unknown(_):
            return -1
        }
    }
    
    /// 是否需要重试
    public var shouldRetry: Bool {
        switch self {
        case .connectionError(_), .timeout, .noInternetConnection:
            return true
        default:
            return false
        }
    }
    
    /// 是否需要重新登录
    public var requiresReauthentication: Bool {
        switch self {
        case .authenticationFailed:
            return true
        default:
            return false
        }
    }
}