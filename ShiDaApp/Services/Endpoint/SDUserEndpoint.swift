//
//  SDUserEndpoint.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import Moya

/// 重置密码通过旧密码的请求参数
struct SDReqParaResetPasswordByOld: Encodable {
    let newPassword: String
    let oldPassword: String
}

/// 重置密码通过验证码的请求参数
struct SDReqParaResetPasswordByCode: Encodable {
    let newPassword: String
    let smsCode: String
}

/// 用户相关的 API 端点
enum SDUserEndpoint {
    
    /// 获取用户设置信息
    case getUserSettings
    /// 获取我的收藏列表
    case getMyCollections(params: SDReqParaMyCollection)
    /// 获取我的纠错列表
    case getMyCorrections(pagination: SDPagination)
    /// 注销账号
    case deleteAccount
    /// 通过旧密码重置密码
    case resetPasswordByOld(params: SDReqParaResetPasswordByOld)
    /// 通过短信验证码重置密码
    case resetPasswordByCode(params: SDReqParaResetPasswordByCode)
    /// 获取我的消息列表
    case getMyMessages(pagination: SDPagination)
    /// 获取未读消息数
    case getUnreadMessageCount
}

extension SDUserEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        
        case .getUserSettings:
            return "/app/my/usersetting/get"
        case .getMyCollections:
            return "/app/my/collection/list"
        case .getMyCorrections:
            return "/app/my/correction/list"
        case .deleteAccount:
            return "/app/my/usersetting/delete"
        case .resetPasswordByOld, .resetPasswordByCode:
            return "/app/my/usersetting/resetpassword"
        case .getMyMessages:
            return "/app/my/message/list"
        case .getUnreadMessageCount:
            return "/app/my/message/unread"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserSettings, .getMyCollections, .getMyCorrections, .getMyMessages, 
             .deleteAccount, .getUnreadMessageCount:
            return .get
        case .resetPasswordByOld, .resetPasswordByCode:
            return .post
       
        }
    }
    
    public var task: Task {
        switch self {
        case .getUserSettings:
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
            return .requestJSONEncodable(pagination)
        case let .getMyMessages(pagination):
            return .requestJSONEncodable(pagination)
        case .deleteAccount:
            return .requestPlain
        case let .resetPasswordByOld(params):
            return .requestJSONEncodable(params)
        case let .resetPasswordByCode(params):
            return .requestJSONEncodable(params)
        case .getUnreadMessageCount:
            return .requestPlain

        }
    }
}
