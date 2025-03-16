//import Foundation
//import ComposableArchitecture
//import Moya
//import OBS
///// 扩展依赖值以包含华为云OBS客户端
//extension DependencyValues {
//    var huaweiCloudClient: SDHuaweiCloudClient {
//        get { self[SDHuaweiCloudClient.self] }
//        set { self[SDHuaweiCloudClient.self] = newValue }
//    }
//}
//
///// 华为云OBS相关的客户端接口
//struct SDHuaweiCloudClient {
//    /// 获取华为云OBS密钥
//    var getOBSAccessKey: @Sendable () async throws -> SDResponseHuaweiCloudAk
//    
//    /// 上传文件到华为云OBS
//    var uploadFile: @Sendable (
//        _ data: Data,
//        _ fileName: String,
//        _ contentType: String,
//        _ progressHandler: @escaping (Float) -> Void
//    ) async throws -> String
//}
//
//extension SDHuaweiCloudClient: DependencyKey {
//    /// 提供实际的华为云OBS客户端实现
//    static var liveValue: Self {
//        let apiService = APIService()
//        let obsService = HuaweiOBSService.shared
//        
//        return Self(
//            getOBSAccessKey: {
//                let credentials = try await apiService.requestResult(SDHuaweiCloudEndpoint.getOBSAccessKey) as SDResponseHuaweiCloudAk
//                obsService.setupOBSClient(with: credentials)
//                return credentials
//            },
//            uploadFile: { data, fileName, contentType, progressHandler in
//                try await obsService.uploadData(
//                    data: data,
//                    fileName: fileName,
//                    contentType: contentType,
//                    progressHandler: progressHandler
//                )
//            }
//        )
//    }
//}
