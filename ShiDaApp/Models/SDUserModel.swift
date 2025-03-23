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

/// 消息状态
public enum SDMessageStatus: Int, Codable, Equatable {
    /// 已读
    case read = 10
    /// 未读
    case unread = 20
}

/// 消息类型
public enum SDMessageType: Int, Codable, Equatable {
    // 这里可以根据实际业务需求添加具体的消息类型
    /// 讨论
    case discussion = 10
    /// 纠错
    case correction = 20
    /// 申请
    case application = 30
    /// 锁定
    case locked = 40
    /// 认证
    case authentication = 50
}

/// 消息列表项模型
public struct SDMessageItem: Codable, Equatable, Identifiable {
    /// 教材封面
    public let bookCover: String?
    /// 教材id
    public let bookId: Int?
    /// 教材名称
    public let bookName: String?
    /// 教材章节名称
    public let chapterName: String?
    /// 消息内容
    public let content: String?
    /// 消息创建时间
    public let createTime: String?
    /// 消息关联表id
    public let detailId: Int?
    /// 消息id
    public let id: Int?
    /// 回复内容
    public let replyRemark: String?
    /// 消息状态: 10 已读, 20 未读
    public let status: SDMessageStatus?
    /// 消息标题
    public let title: String?
    /// 消息类型
    public let type: SDMessageType?
}

/// 消息列表响应
public typealias SDMessageListResult = SDPageResponse<SDMessageItem>

extension SDMessageItem: SDMockable {}
extension SDMessageListResult {
    public static var mock: SDMessageListResult {
        SDPageResponse(
            currentPage: 1,
            offset: 0,
            pageSize: 10,
            realSize: 5,
            rows: [
                // 讨论类型消息
                SDMessageItem(
                    bookCover: "https://example.com/cover1.jpg",
                    bookId: 101,
                    bookName: "高等数学",
                    chapterName: "微分方程",
                    content: "有关微分方程解法的讨论",
                    createTime: "2025-03-20 14:30:00",
                    detailId: 1001,
                    id: 1,
                    replyRemark: "感谢您参与讨论",
                    status: .unread,
                    title: "讨论回复通知",
                    type: .discussion
                ),
                // 纠错类型消息
                SDMessageItem(
                    bookCover: "https://example.com/cover2.jpg",
                    bookId: 102,
                    bookName: "线性代数",
                    chapterName: "矩阵运算",
                    content: "您的纠错反馈已处理",
                    createTime: "2025-03-19 10:15:00",
                    detailId: 1002,
                    id: 2,
                    replyRemark: "感谢您的反馈，我们已更正相关内容",
                    status: .unread,
                    title: "纠错反馈处理通知",
                    type: .correction
                ),
                // 申请类型消息
                SDMessageItem(
                    bookCover: "https://example.com/cover3.jpg",
                    bookId: 103,
                    bookName: "概率论",
                    chapterName: "随机变量",
                    content: "您的申请已通过审核",
                    createTime: "2025-03-18 09:45:00",
                    detailId: 1003,
                    id: 3,
                    replyRemark: "您的申请已通过，请查看详情",
                    status: .read,
                    title: "用书申请",
                    type: .application
                ),
                // 锁定类型消息
                SDMessageItem(
                    bookCover: "https://example.com/cover4.jpg",
                    bookId: 104,
                    bookName: "物理学",
                    chapterName: "力学",
                    content: "您的账号已被临时锁定",
                    createTime: "2025-03-17 16:20:00",
                    detailId: 1004,
                    id: 4,
                    replyRemark: "由于异常操作，您的账号已被临时锁定，请联系管理员",
                    status: .read,
                    title: "账号锁定通知",
                    type: .locked
                ),
                // 认证类型消息
                SDMessageItem(
                    bookCover: "https://example.com/cover5.jpg",
                    bookId: 105,
                    bookName: "化学",
                    chapterName: "有机化学",
                    content: "您的身份认证已通过",
                    createTime: "2025-03-16 11:30:00",
                    detailId: 1005,
                    id: 5,
                    replyRemark: "恭喜您通过身份认证，现在可以使用更多功能",
                    status: .unread,
                    title: "身份认证通知",
                    type: .authentication
                )
            ],
            total: 5,
            totalPage: 1
        )
    }
}
