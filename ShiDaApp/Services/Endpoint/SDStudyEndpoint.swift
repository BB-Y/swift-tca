//
//  SDStudyEndpoint.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import Moya

/// 学习相关的 API 端点
enum SDStudyEndpoint {
    
    /// 获取教师用书页面列表
    case getTeacherBookPageList(pagination: SDPagination)
}

extension SDStudyEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .getTeacherBookPageList:
            return "/app/teaching/dbook/pagelist"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getTeacherBookPageList:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case let .getTeacherBookPageList(pagination):
            return .requestJSONEncodable(pagination)
        }
    }
}