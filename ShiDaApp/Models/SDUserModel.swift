//
//  SDUserModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation





/// 第三方账号信息模型
public struct SDThirdPartyAccountInfo: Codable, Equatable {
    let id: Int?
    let thirdpartyAccount: String?
    let thirdpartyAvatarUrl: String?
    let thirdpartyBindTime: String?
    let thirdpartyBindType: SDThirdPartyType?
    let thirdpartyMailbox: String?
    let thirdpartyNickName: String?
    let userId: Int?
    
    
}

/// 用户信息响应模型
public struct SDResponseUserInfo: Codable, Equatable {
    let id: Int?
    let name: String?
    let phone: String?
    let thirdparthAccountList: [SDThirdPartyAccountInfo]?
    let userType: SDUserType?
}

/// 我的收藏请求参数
public struct SDReqParaMyCollection: Codable, Equatable {
    /// 分页参数
    public let pagination: SDPagination
    /// 搜索关键词（可选）
    public let searchkey: String?
    
    public static func `default`(searchkey: String? = nil) -> SDReqParaMyCollection {
        SDReqParaMyCollection(searchkey: searchkey, pagination: .default)
    }
    
    public var nextPage: SDReqParaMyCollection {
        SDReqParaMyCollection(searchkey: searchkey, pagination: pagination.nextPage)
    }
    
    public init(searchkey: String? = nil, pagination: SDPagination = .default) {
        self.searchkey = searchkey
        self.pagination = pagination
    }
}


/// 纠错类型
public enum SDCorrectionType: Int, Codable, Equatable {
    /// 错别字
    case typo = 10
    /// 内容错误
    case content = 20
    /// 图片错误
    case image = 30
    /// 其他
    case other = 40
}

/// 纠错回复状态
public enum SDCorrectionReplyStatus: Int, Codable, Equatable {
    /// 待处理
    case pending = 10
    /// 已处理
    case processed = 20
}

/// 纠错信息响应模型
public struct SDResponseCorrectionInfo: Codable, Equatable, Identifiable {
 
    /// 文章ID
    public let articleId: Int?
    /// 文章编号
    public let articleNumber: Int?
    /// 章节ID
    public let chapterId: Int?
    /// 章节名称
    public let chapterName: String?
    /// 纠错反馈内容
    public let content: String?
    /// 电子书ID
    public let dbookId: Int?
    /// 电子书名称
    public let dbookName: String?
    /// 纠错ID
    public let id: Int
    /// 位置信息
    public let position: String?
    /// 回复内容
    public let replyContent: String?
    /// 回复状态
    public let replyStatus: SDCorrectionReplyStatus?
    /// 纠错原文
    public let text: String?
    /// 纠错类型
    public let type: SDCorrectionType?
    public let createDatetime: String?

    
}

/// 纠错列表响应
public typealias SDCorrectionListResult = SDPageResponse<SDResponseCorrectionInfo>
extension SDResponseCorrectionInfo: SDMockable {}
