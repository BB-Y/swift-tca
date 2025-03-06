//
//  SDAPIServiceTests.swift
//  ShiDaAppTests
//
//  Created by Trae AI on 2025/2/28.
//

import Testing
import Foundation
import Moya
import CodableWrappers

@testable import ShiDaApp

struct SDAPIServiceTests {
    
    // 测试成功请求
    @Test func testSuccessfulRequest() async throws {
        // 创建模拟提供者
        
//        let service = APIService()
//        
//        let result = try await service.requestResult(TestEndpoint.test, type: TestModel.self)
//      
//        
//        // 验证结果
//        #expect(result.id == 1)
//        #expect(result.name == "测试数据")
    }
    
//    // 测试服务器错误
//    @Test func testServerError() async throws {
//        // 执行请求并验证错误
//        do {
//            _ = try await service.requestResult(TestEndpoint.test, type: TestModel.self)
//            #expect(false, "应该抛出错误但没有")
//        } catch let error as APIError {
//            #expect(error.errorDescription?.contains("请求参数错误") == true)
//        }
//    }
    
//    // 测试网络错误
//    @Test func testNetworkError() async throws {
//        // 创建模拟提供者
//        let mockProvider = MockAPIProvider()
//        let service = TestAPIService(provider: mockProvider)
//        
//        // 设置模拟响应
//        let mockError = NSError(domain: "com.test.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "网络连接失败"])
//        mockProvider.mockResponse = .failure(MoyaError.underlying(mockError, nil))
//        
//        // 执行请求并验证错误
//        do {
//            _ = try await service.requestResult(TestEndpoint.test, type: TestModel.self)
//            #expect(false, "应该抛出错误但没有")
//        } catch let error as APIError {
//            #expect(error.errorDescription?.contains("网络错误") == true)
//        }
//    }
//    
//    // 测试未授权错误
//    @Test func testUnauthorizedError() async throws {
//        // 创建模拟提供者
//        let mockProvider = MockAPIProvider()
//        let service = TestAPIService(provider: mockProvider)
//        
//        // 设置模拟响应
//        mockProvider.mockResponse = .success(Response(
//            statusCode: 401,
//            data: Data(),
//            response: HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
//        ))
//        
//        // 执行请求并验证错误
//        do {
//            _ = try await service.request(TestEndpoint.test)
//            #expect(false, "应该抛出错误但没有")
//        } catch let error as APIError {
//            //#expect(error == .unauthorized)
//        }
//    }
}

// 测试用的API端点
private enum TestEndpoint: SDEndpoint {
    var modelType: any Codable.Type {
        return UserInfo.self
    }
    
    
    
    case test
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var endpointPath: String {
        return "/test"
    }
    
    var sampleData: Data {
        let model = TestModel(id: 1, name: "dmaasd")
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(model)
        return jsonData
//        let jsonString = String(data: jsonData, encoding: .utf8)
//        return "123".data(using: .utf8)!
    }
}

// 测试用的模型
@CustomCodable
private struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}

// 模拟API提供者
private class MockAPIProvider {
    var mockResponse: Result<Moya.Response, MoyaError> = .failure(MoyaError.requestMapping("默认错误"))
    
    func request(_ target: MultiTarget, completion: @escaping (Result<Moya.Response, MoyaError>) -> Void) {
        completion(mockResponse)
    }
}


