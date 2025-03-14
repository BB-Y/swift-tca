//
//  SDHomeModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/10.
//

import Foundation
import CodableWrappers
//MARK: - 首页模型

/// 首页栏目列表数据传输对象
public struct SDResponseHomeSection: Codable, Equatable, Identifiable {
    /// 数据列表
    let dataList: [SDResponseHomeListItem]?
    /// 栏目ID
    public let id: Int
    /// 备注
    let memo: String?
    /// 栏目名称
    let name: String?
    /// 排序序号
    let seq: Int?
    /// 排版样式
    var style: SDHomeSectionStyle?
}

/// 栏目排版样式
public enum SDHomeSectionStyle: Int, Codable, Equatable {
    /// 头部banner
    case headerBanner = 1
    /// 已删除不需要了
    case middleBanner = 2
    /// 推荐位E型
    case recommendTypeE = 3
    /// 推荐位B型
    case recommendTypeB = 4
    /// 推荐位A型
    case recommendTypeA = 5
    /// 推荐位C行
    case recommendTypeC = 6
    /// 推荐位D型
    case recommendTypeD = 7
    /// 推荐位G型
    case recommendTypeG = 8
    /// 图书板块（自动滑动）
    case bookSectionSliding = 9
    /// 已删除不需要了
    case bookSectionFixed = 10
}

/// 栏目关联数据传输对象
public struct SDResponseHomeListItem: Codable, Equatable, Identifiable, Hashable {
    
    /// 栏目ID
    let appSectionId: Int?
    /// 数据封面
    let dataCover: String?
    /// 数据ID
    let dataId: Int?
    /// 数据名称
    let dataName: String?
    /// 数据摘要
    let dataSummary: String?
    /// 数据类型
    let dataType: SDHomeSectionDataType?
    /// 排序序号
    let seq: Int?
    
    public var id: Int {
        dataId ?? 0
    }
}

/// 栏目数据类型
public enum SDHomeSectionDataType: Int, Codable, Equatable {
    /// 教材
    case textbook = 10
    /// 轮播图
    case carousel = 20
    /// 合作院校
    case cooperativeSchool = 30
    /// 直播
    case live = 40
}

/// 栏目详情书籍列表数据传输对象
@CustomCodable
public struct SDResponseHomeSectionBook: Codable, Equatable, Identifiable {
    /// 教材作者信息
    let authorList: [SDResponseBookCopyrightTeam]?
    /// 教材封面
    let cover: String?
    /// 教材ID
    
    public let id: Int
    /// 简介
    let introduction: String?
    /// 教材名称
    let name: String?
    /// 教材售价
    let sellPrice: Double?
    
    let isbn: String?

    // 添加一个计算属性用于获取格式化后的作者信息
    var formattedAuthors: String {
        guard let authors = authorList, !authors.isEmpty else { return "" }
        
        return authors.compactMap { author in
            guard let typeName = author.typeName, !typeName.isEmpty,
                  let name = author.name, !name.isEmpty else {
                return nil
            }
            return "\(typeName)：\(name)"
        }.joined(separator: "/")
    }
}

/// 教材版权团队数据传输对象
@CustomCodable
public struct SDResponseBookCopyrightTeam: Codable, Equatable {
    /// 创建时间
    @CodingUses<TimestampStringCoder>
    var createTime: String
    /// 创建用户ID
    let createUserId: Int?
    /// 教材ID
    let dbookId: Int?
    /// ID
    let id: Int?
    /// 备注
    let memo: String?
    /// 名称
    let name: String?
    /// 类型名称
    let typeName: String?
   
}

/// 合作院校数据传输对象
public struct SDResponseHomeSectionSchool: Codable, Equatable, Identifiable {
    /// 教材数量
    let dbookCount: Int?
    /// 学校logo
    let iconUrl: String?
    /// 学校id
    public let id: Int
    /// 学校名称
    let name: String?
    /// 学校类型：本科/高职/中职
    let type: String?
}


