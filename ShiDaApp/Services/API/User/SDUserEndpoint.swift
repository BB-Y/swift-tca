//
//  SDUserEndpoint.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import Moya

/// 用户相关的 API 端点
enum SDUserEndpoint {
    /// 获取用户信息
    case getUserInfo
}

extension SDUserEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .getUserInfo:
            return "/app/my/usersetting/get"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
}