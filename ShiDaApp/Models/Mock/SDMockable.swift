//
//  SDMockable.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
protocol SDMockable {
    static var json: String{get}
}
extension SDMockable where Self: Codable{
    static var mock: Self {
        try! JSONDecoder().decode(Self.self, from: json.data(using: .utf8)!)
    }
}
extension SDResponseLogin: SDMockable{
    static var json: String {
        """
{
    "address": "浙江省杭州市西湖区浙江大学紫金港校区",
    "authStatus": 10,
    "city": 330100,
    "createDatetime": "2025-03-06T01:26:30.289Z",
    "deparment": "计算机科学与技术学院",
    "field": "计算机科学",
    "id": 10086,
    "inputMajor": "计算机科学与技术",
    "jobId": "ZJU10086",
    "jobTitle": "教授",
    "lastLoginDatetime": "2025-03-06T01:26:30.289Z",
    "level": "高级",
    "mail": "professor@zju.edu.cn",
    "major": "计算机科学与技术",
    "majorId": 0825,
    "name": "张教授",
    "phone": "13800138000",
    "photo": "https://example.com/photos/avatar.jpg",
    "position": "教师",
    "postalCode": "310058",
    "province": 330000,
    "schoolId": 10001,
    "status": 1,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userType": 10
}
"""
    }
    
    
}
