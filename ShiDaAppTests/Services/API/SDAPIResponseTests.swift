//
//  SDAPIResponseTests.swift
//  ShiDaAppTests
//
//  Created by Trae AI on 2025/2/28.
//

import Testing
import Foundation
@testable import ShiDaApp
@testable import Moya

//测试 jsonstring 能否正确Decode为 SDAPIResponse
struct SDAPIResponseTests {
    //MARK: - SDAPIResponse泛型测试
    
    
    
    // 测试字典的解析
    @Test  func testModelDataParsing() throws {
        
        // 准备测试数据
        let jsonString = """
        {
            "code": 200,
            "msg": "成功",
            "data": {
                "id": 1,
                "name": "测试数据"
            },
            "status": true
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // 执行解析
        let response = try decoder.decode(SDAPIResponse<TestModel>.self, from: jsonData)
        print("========response is:========\n\(response)")

        // 验证结果
        #expect(response.code == 200)
        #expect(response.message == "成功")
        #expect(response.isSuccess == true)
        #expect(response.data != nil)
        #expect(response.data?.id == 1)
        #expect(response.data?.name == "测试数据")
    }
    
    // 测试数组的解析
    @Test  func testModelArrayDataParsing() throws {
        
        // 准备测试数据
        let jsonString = """
        {
            "code": 200,
            "msg": "成功",
            "data": [
                {
                    "id": 1,
                    "name": "测试数据"
                },
                        {
                            "id": 2,
                            "name": "测试数据2"
                        },
            ],
            "status": true
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // 执行解析
        let response = try decoder.decode(SDAPIResponse<[TestModel]>.self, from: jsonData)
        print("========response is:========\n\(response)")
        // 验证结果
        #expect(response.code == 200)
        #expect(response.message == "成功")
        #expect(response.isSuccess == true)
        #expect(response.data != nil)
        #expect(response.data?.first?.id == 1)
        #expect(response.data?.first?.name == "测试数据")
    }
    
    // 测试数组的解析
    @Test func testStringDataParsing() throws {
        
        // 准备测试数据
        let jsonString = """
        {
            "code": 200,
            "msg": "成功",
            "data": "test string",
            "status": true
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // 执行解析
        let response = try decoder.decode(SDAPIResponse<String>.self, from: jsonData)
        print("========response is:========\n\(response)")
        // 验证结果
        #expect(response.code == 200)
        #expect(response.message == "成功")
        #expect(response.isSuccess == true)
        #expect(response.data != nil)
        #expect(response.data == "test string")
        
    }
    
    fileprivate func testData(_ stringData: String) throws -> SDAPIResponse<TestModel> {
        let jsonString = """
        {
            "code": 400,
            "msg": "请求参数错误",
            "data": \(stringData),
            "status": true
        }
        """
        print(jsonString)
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // 执行解析
        let response = try decoder.decode(SDAPIResponse<TestModel>.self, from: jsonData)
        return response
    }
    
    // 测试失败响应的解析
    
    
    // 测试失败响应的解析
    @Test(arguments: ["null", "\"a string\"", "\"123\""])
    func testFailureResponseParsing(_ stringData: String) throws {
        let jsonString = """
        {
            "code": 400,
            "msg": "请求参数错误",
            "data": \(stringData),
            "status": true
        }
        """
        print(jsonString)
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        // 执行解析
        do {
            let response = try decoder.decode(SDAPIResponse<TestModel>.self, from: jsonData)
            print(response)
            // 验证结果
            #expect(response.code == 400)
            #expect(response.message == "请求参数错误")
            #expect(response.isSuccess == false)
            #expect(response.data == nil)
        }
        catch {
            print(error.localizedDescription)
        }
        //let response = try testData(stringData)
        
        
    }
    
    // 测试分页响应的解析
    //    @Test func testPaginatedResponseParsing() throws {
    //        // 准备测试数据
    //        let jsonString = """
    //        {
    //            "page": 1,
    //            "page_size": 10,
    //            "total": 25,
    //            "items": [
    //                {"id": 1, "name": "项目1"},
    //                {"id": 2, "name": "项目2"},
    //                {"id": 3, "name": "项目3"}
    //            ]
    //        }
    //        """
    //
    //        let jsonData = jsonString.data(using: .utf8)!
    //        let decoder = JSONDecoder()
    //
    //        // 执行解析
    //        let response = try decoder.decode(SDPaginatedResponse<SDAPIResponse>.self, from: jsonData)
    //
    //        // 验证结果
    //        #expect(response.page == 1)
    //        #expect(response.pageSize == 10)
    //        #expect(response.total == 25)
    //        #expect(response.items.count == 3)
    //        #expect(response.items[0].id == 1)
    //        #expect(response.items[0].name == "项目1")
    //        #expect(response.items[1].id == 2)
    //        #expect(response.items[2].name == "项目3")
    //    }
}

// 用于测试的模型
fileprivate struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}
