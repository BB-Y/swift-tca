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
    /// 获取我的收藏列表
    case getMyCollections(params: SDReqParaMyCollection)
    /// 获取我的纠错列表
    case getMyCorrections(pagination: SDPagination)
}

extension SDUserEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case .getUserInfo:
            return "/app/my/usersetting/get"
        case .getMyCollections:
            return "/app/my/collection/list"
        case .getMyCorrections:
            return "/app/my/correction/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo, .getMyCollections, .getMyCorrections:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
            
        case let .getMyCollections(params):
            var parameters: [String: Any] = [
                "offset": params.pagination.offset,
                "pageSize": params.pagination.pageSize
            ]
            
            if let searchkey = params.searchkey {
                parameters["searchkey"] = searchkey
            }
            
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
            
        case let .getMyCorrections(pagination):
            let parameters: [String: Any] = [
                "offset": pagination.offset,
                "pageSize": pagination.pageSize
            ]
            
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}