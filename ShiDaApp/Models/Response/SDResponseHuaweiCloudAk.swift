import Foundation

/// 华为云OBS密钥响应模型
struct SDResponseHuaweiCloudAk: Codable {
    let ak: String?
    let bucket: String?
    let endpoint: String?
    let host: String?
    let projectId: String?
    let sk: String?
}