//
//  SDNetworkErrorTests.swift
//  ShiDaAppTests
//
//  Created by Trae AI on 2025/2/28.
//

import Testing
import Foundation
@testable import ShiDaApp

struct SDNetworkErrorTests {
    
    // 测试错误描述
    @Test func testErrorDescription() {
        // 测试连接错误
        let connectionError = NSError(domain: "com.test.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "连接失败"])
        let networkError1 = SDNetworkError.connectionError(connectionError)
        #expect(networkError1.errorDescription?.contains("网络连接错误") == true)
        #expect(networkError1.errorDescription?.contains("连接失败") == true)
        
        // 测试超时错误
        let networkError2 = SDNetworkError.timeout
        #expect(networkError2.errorDescription == "请求超时")
        
        // 测试服务器错误
        let networkError3 = SDNetworkError.serverError(code: 500, message: "内部服务器错误")
        #expect(networkError3.errorDescription?.contains("服务器错误") == true)
        #expect(networkError3.errorDescription?.contains("内部服务器错误") == true)
        
        // 测试认证失败
        let networkError4 = SDNetworkError.authenticationFailed
        #expect(networkError4.errorDescription == "认证失败")
    }
    
    // 测试错误代码
    @Test func testErrorCode() {
        // 测试连接错误代码
        let connectionError = NSError(domain: "com.test.error", code: -1, userInfo: nil)
        let networkError1 = SDNetworkError.connectionError(connectionError)
        #expect(networkError1.errorCode == -1001)
        
        // 测试超时错误代码
        let networkError2 = SDNetworkError.timeout
        #expect(networkError2.errorCode == -1002)
        
        // 测试服务器错误代码
        let networkError3 = SDNetworkError.serverError(code: 500, message: "内部服务器错误")
        #expect(networkError3.errorCode == 500)
        
        // 测试认证失败错误代码
        let networkError4 = SDNetworkError.authenticationFailed
        #expect(networkError4.errorCode == 401)
    }
    
    // 测试重试逻辑
    @Test func testShouldRetry() {
        // 应该重试的错误
        let connectionError = NSError(domain: "com.test.error", code: -1, userInfo: nil)
        let networkError1 = SDNetworkError.connectionError(connectionError)
        #expect(networkError1.shouldRetry == true)
        
        let networkError2 = SDNetworkError.timeout
        #expect(networkError2.shouldRetry == true)
        
        let networkError3 = SDNetworkError.noInternetConnection
        #expect(networkError3.shouldRetry == true)
        
        // 不应该重试的错误
        let networkError4 = SDNetworkError.serverError(code: 500, message: "内部服务器错误")
        #expect(networkError4.shouldRetry == false)
        
        let networkError5 = SDNetworkError.authenticationFailed
        #expect(networkError5.shouldRetry == false)
    }
    
    // 测试重新认证逻辑
    @Test func testRequiresReauthentication() {
        // 需要重新认证的错误
        let networkError1 = SDNetworkError.authenticationFailed
        #expect(networkError1.requiresReauthentication == true)
        
        // 不需要重新认证的错误
        let connectionError = NSError(domain: "com.test.error", code: -1, userInfo: nil)
        let networkError2 = SDNetworkError.connectionError(connectionError)
        #expect(networkError2.requiresReauthentication == false)
        
        let networkError3 = SDNetworkError.serverError(code: 500, message: "内部服务器错误")
        #expect(networkError3.requiresReauthentication == false)
    }
}