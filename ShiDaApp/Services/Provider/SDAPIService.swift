import Foundation
import Moya
import Combine
import ComposableArchitecture
import CodableWrappers

typealias Effect = ComposableArchitecture.Effect
/// API 服务协议
protocol APIServiceType {
    
    
    /// 发送请求并返回原始数据
    /// - Parameter target: API 目标
    /// - Returns: 包含成功或失败结果的 Result
    func request(_ target: any TargetType, result: @escaping (Result<Response, APIError>) -> Void)
    
    /// 发送请求并返回原始数据
    /// - Parameter target: API 目标
    /// - Returns: Response 对象
    /// - Throws: APIError
    func request(_ target: any TargetType) async throws -> Response
       
    
    
    /// 发送请求并返回 Result 类型
    /// - Parameters:
    ///   - target: API 目标
    ///   - type: 解码类型
    /// - Returns: 包含成功或失败结果的 Result
    func requestResult<T: Codable>(_ target: any TargetType, type: T.Type, result: @escaping (Result<T, APIError>) -> Void)
    
    /// 发送请求并返回 Result 类型
    /// - Parameters:
    ///   - target: API 目标
    ///   - type: 解码类型
    /// - Returns: 包含成功或失败结果的 Result
    func requestResult<T: Codable>(_ target: any TargetType, type: T.Type) async throws -> T
    
   
    
}

/// API 服务实现 , @unchecked Sendable?
public final class APIService: APIServiceType {
    
    
    
    
    
    
    private let provider: MoyaProvider<MultiTarget>
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfiguration.timeoutInterval
        configuration.headers = .init(APIConfiguration.defaultHeaders)
        
        provider = MoyaProvider<MultiTarget>(
            endpointClosure: { target in
                MoyaProvider.defaultEndpointMapping(for: target).adding(newHTTPHeaderFields: APIConfiguration.defaultHeaders)
            },
            session: Session(configuration: configuration),
            plugins: APIConfiguration.defaultPlugins
        )
    }
    public func request(_ target: any TargetType,  result: @escaping (Result<Response, APIError>) -> Void) {
        

        provider.request(.target(target)) { response in
            switch response {
            case .success(let moyaResponse):
                switch moyaResponse.statusCode {
                case 200...299:
                    result(.success(moyaResponse))
                case 401:
                    result(.failure(.unauthorized))
                default:
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: moyaResponse.data) {
                        result(.failure(.serverError(code: moyaResponse.statusCode, message: errorResponse.message)))
                    } else {
                        result(.failure(.invalidResponse))
                    }
                }
            case .failure(let error):
                result(.failure(.networkError(error)))
            }
            
        }
        
        
    }
   
    
    public func request(_ target: any TargetType) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            request(target) { result in
                switch result {
                case .success(let success):
                    continuation.resume(with: result)

                case .failure(let failure):
                    continuation.resume(throwing: failure)

                }
            }
        }
    }
    func requestResult<T>(_ target: any Moya.TargetType, type: T.Type, result: @escaping (Result<T, APIError>) -> Void) where T : Codable {
        request(target) { response in
            switch response {
            case .success(let moyaResponse):
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(SDAPIResponse<T>.self, from: moyaResponse.data)
                    
                    if apiResponse.isSuccess, let data = apiResponse.data {
                        result(.success(data))
                    } else {
                        result(.failure(.serverError(code: apiResponse.code, message: "")))
                    }
                } catch {
                    result(.failure(.decodingError(error)))
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    

//    
//    func requestResult<T>(_ target: any Moya.TargetType, type: any Codable) async throws -> T where T : Codable {
//        try await withCheckedThrowingContinuation { continuation in
//            requestResult(target, type: type) { result in
//                switch result {
//                case .success(let success):
//                    continuation.resume(with: result)
//
//                case .failure(let failure):
//                    continuation.resume(throwing: failure)
//
//                }
//            }
//        }
//        
//    }
    
    func requestResult<T>(_ target: any Moya.TargetType, type: T.Type) async throws -> T where T : Codable {
        
        try await withCheckedThrowingContinuation { continuation in
            requestResult(target, type: type) { result in
                switch result {
                case .success(let success):
                    continuation.resume(with: result)

                case .failure(let failure):
                    continuation.resume(throwing: failure)

                }
            }
        }
    }

  
   
}

//// 扩展 Publisher 以支持 async/await
//extension Publisher {
//    func async() async throws -> Output {
//        try await withCheckedThrowingContinuation { continuation in
//            var cancellable: AnyCancellable?
//            
//            cancellable = self.sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                    cancellable?.cancel()
//                },
//                receiveValue: { value in
//                    continuation.resume(returning: value)
//                    cancellable?.cancel()
//                }
//            )
//        }
//    }
//}

// 扩展 Result 以支持 TCA
extension Result {
    func getOrThrow() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

/// 错误响应模型
private struct ErrorResponse: Decodable {
    let message: String
}

extension Data {
    func decode<T: Decodable>(to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(T.self, from: self)
        if let model {
            return model
        } else {
            return nil
        }
    }
}

extension Data {
    
    static func getData<T: Encodable>(from model: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(model)
    }
}


