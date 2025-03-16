//import Foundation
//import OBS // 请确保导入华为云OBS SDK
//
///// 华为云OBS服务实现
//class HuaweiOBSService {
//    static let shared = HuaweiOBSService()
//    
//    private var client: OBSClient?
//    private var credentials: SDResponseHuaweiCloudAk?
//    
//    private init() {}
//    
//    /// 初始化OBS客户端
//    func setupOBSClient(with credentials: SDResponseHuaweiCloudAk) {
//        guard let ak = credentials.ak, let sk = credentials.sk, let endpoint = credentials.endpoint else {
//            print("缺少必要的OBS凭证信息")
//            return
//        }
//        
//        self.credentials = credentials
//        
//        // 初始化OBS客户端
//        let credentialProvider = OBSStaticCredentialProvider(accessKey: ak, secretKey: sk)
//        let configuration = OBSServiceConfiguration(urlString: endpoint, credentialProvider: credentialProvider)
//        
//        // 创建客户端
//        self.client = OBSClient(configuration: configuration)
//        
//        // 如果需要，确保存储桶存在
//        if let bucket = credentials.bucket {
//            ensureBucketExists(bucketName: bucket)
//        }
//    }
//    
//    /// 确保存储桶存在，如果不存在则创建
//    private func ensureBucketExists(bucketName: String) {
//        guard let client = self.client else {
//            print("OBS客户端未初始化")
//            return
//        }
//        
//        let request = OBSCreateBucketRequest(bucketName: bucketName)
//        client.createBucket(request) { response, error in
//            if let error = error {
//                // 如果错误是因为存储桶已存在，可以忽略
//                print("创建存储桶失败: \(error.localizedDescription)")
//            } else if let response = response {
//                print("存储桶创建成功，位置: \(response.location ?? "未知")")
//            }
//        }
//    }
//    
//    /// 上传数据到OBS
//    /// - Parameters:
//    ///   - data: 要上传的数据
//    ///   - fileName: 文件名
//    ///   - contentType: 内容类型
//    ///   - progressHandler: 上传进度回调
//    /// - Returns: 上传成功后的ETag或对象URL
//    func uploadData(data: Data, fileName: String, contentType: String, progressHandler: @escaping (Float) -> Void) async throws -> String {
//        guard let client = self.client, let credentials = self.credentials, let bucket = credentials.bucket else {
//            throw NSError(domain: "HuaweiOBSService", code: -1, userInfo: [NSLocalizedDescriptionKey: "OBS客户端未初始化或缺少必要信息"])
//        }
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            
//            guard let request = OBSPutObjectWithDataRequest(bucketName: bucket, objectKey: fileName, uploadData: Data()) else {
//                return continuation.resume(throwing: NSError())
//            }
//            request.contentType = OBSContentType.PNG
//            
//            
//            // 设置上传进度回调
//            request.uploadProgressBlock = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
//                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
//                progressHandler(progress)
//            }
//            
//            // 执行上传
//            client.putObject(request) { response, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let response = response  {
//                    let etag = response.etag
//                    // 返回ETag或构建对象URL
//                    if let host = self.credentials?.host {
//                        let objectUrl = "\(host)/\(fileName)"
//                        continuation.resume(returning: objectUrl)
//                    } else {
//                        continuation.resume(returning: etag)
//                    }
//                } else {
//                    continuation.resume(throwing: NSError(domain: "HuaweiOBSService", code: -2, userInfo: [NSLocalizedDescriptionKey: "上传成功但未返回etag"]))
//                }
//            }
//        }
//    }
//    
//    /// 上传本地文件到OBS
//    /// - Parameters:
//    ///   - fileURL: 本地文件URL
//    ///   - fileName: 对象键（文件在OBS中的路径）
//    ///   - progressHandler: 上传进度回调
//    /// - Returns: 上传成功后的ETag或对象URL
//    func uploadFile(fileURL: URL, fileName: String, progressHandler: @escaping (Float) -> Void) async throws -> String {
//        guard let client = self.client, let credentials = self.credentials, let bucket = credentials.bucket else {
//            throw NSError(domain: "HuaweiOBSService", code: -1, userInfo: [NSLocalizedDescriptionKey: "OBS客户端未初始化或缺少必要信息"])
//        }
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            let request = OBSPutObjectWithFileRequest(bucketName: bucket, objectKey: fileName, uploadFilePath: fileURL.path)
//            
//            // 设置上传进度回调
//            request?.uploadProgressBlock = { bytesSent, totalBytesSent, totalBytesExpectedToSend in
//                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
//                progressHandler(progress)
//            }
//            
//            // 执行上传
//            client.putObject(request) { response, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let response = response  {
//                    let etag = response.etag
//                    // 返回ETag或构建对象URL
//                    if let host = self.credentials?.host {
//                        let objectUrl = "\(host)/\(fileName)"
//                        continuation.resume(returning: objectUrl)
//                    } else {
//                        continuation.resume(returning: etag)
//                    }
//                } else {
//                    continuation.resume(throwing: NSError(domain: "HuaweiOBSService", code: -2, userInfo: [NSLocalizedDescriptionKey: "上传成功但未返回etag"]))
//                }
//            }
//        }
//    }
//}
