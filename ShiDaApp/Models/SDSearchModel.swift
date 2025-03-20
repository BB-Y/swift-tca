//
//  SDSearchModel.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation

//MARK: - 分页参数
/// 分页请求参数
public struct SDPagination: Codable, Equatable {
    /// 偏移量，初始值为1
    public let offset: Int
    /// 每页数量
    public let pageSize: Int
    
    /// 默认分页参数
    public static let `default` = SDPagination(offset: 1, pageSize: 10)
    
    /// 下一页的分页参数
    public var nextPage: SDPagination {
        SDPagination(offset: offset + 1, pageSize: pageSize)
    }
    
    public init(offset: Int, pageSize: Int) {
        self.offset = offset
        self.pageSize = pageSize
    }
}

//MARK: - 搜索请求参数
/// 基础搜索请求参数
public struct SDReqParaBaseSearch: Codable, Equatable {
    /// 分页参数
    public let pagination: SDPagination
    
    public static let `default` = SDReqParaBaseSearch(pagination: .default)
    
    public var nextPage: SDReqParaBaseSearch {
        SDReqParaBaseSearch(pagination: pagination.nextPage)
    }
    
    public init(pagination: SDPagination = .default) {
        self.pagination = pagination
    }
}

/// 关键词搜索请求参数
public struct SDReqParaKeywordSearch: Codable,Equatable {
    /// 分页参数
    public let pagination: SDPagination
    /// 搜索关键词
    public let keyword: String
    
    public static func `default`(keyword: String) -> SDReqParaKeywordSearch {
        SDReqParaKeywordSearch(keyword: keyword, pagination: .default)
    }
    
    public var nextPage: SDReqParaKeywordSearch {
        SDReqParaKeywordSearch(keyword: keyword, pagination: pagination.nextPage)
    }
    
    public init(keyword: String, pagination: SDPagination = .default) {
        self.keyword = keyword
        self.pagination = pagination
    }
}

/// 分类搜索请求参数
public struct SDReqParaCategorySearch: Codable, Equatable {
    /// 分页参数
    public let pagination: SDPagination
    /// 搜索关键词
    public let keyword: String
    /// 分类ID
    public let categoryId: Int?
    /// 排序类型（0: 最新发布, 1: 综合推荐）
    public let sortType: SDSearchSortType
    
    public static func `default`(keyword: String, categoryId: Int? = nil, sortType: SDSearchSortType = .latest) -> SDReqParaCategorySearch {
        SDReqParaCategorySearch(keyword: keyword, categoryId: categoryId, sortType: sortType, pagination: .default)
    }
    
    public var nextPage: SDReqParaCategorySearch {
        SDReqParaCategorySearch(keyword: keyword, categoryId: categoryId, sortType: sortType, pagination: pagination.nextPage)
    }
    
    public init(keyword: String, categoryId: Int?, sortType: SDSearchSortType, pagination: SDPagination = .default) {
        self.keyword = keyword
        self.categoryId = categoryId
        self.sortType = sortType
        self.pagination = pagination
    }
}

/// 高级搜索请求参数
public struct SDReqParaAdvancedSearch: Codable, Equatable {
    /// 分页参数
    public let pagination: SDPagination
    /// 搜索关键词
    public let keyword: String?
    /// 学校ID
    public let schoolId: String?
    /// 分类ID
    public let categoryId: String?
    /// 排序类型（0: 最新发布, 1: 综合推荐）
    public let sortType: Int?
    /// 教材类型（10: 数字教材, 20: 纸制教材, 30: PDF教材）
    public let type: Int?
    /// 创建开始时间
    public let startTime: String?
    /// 创建结束时间
    public let endTime: String?
    
    public static let `default` = SDReqParaAdvancedSearch(pagination: .default)
    
    public var nextPage: SDReqParaAdvancedSearch {
        SDReqParaAdvancedSearch(
            keyword: keyword,
            schoolId: schoolId,
            categoryId: categoryId,
            sortType: sortType,
            type: type,
            startTime: startTime,
            endTime: endTime,
            pagination: pagination.nextPage
        )
    }
    
    public init(
        keyword: String? = nil,
        schoolId: String? = nil,
        categoryId: String? = nil,
        sortType: Int? = nil,
        type: Int? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        pagination: SDPagination = .default
    ) {
        self.keyword = keyword
        self.schoolId = schoolId
        self.categoryId = categoryId
        self.sortType = sortType
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.pagination = pagination
    }
}

//MARK: - 搜索排序类型
/// 搜索排序类型
public enum SDSearchSortType: Int, Codable, Equatable, CaseIterable {
    /// 最新发布
    case latest = 0
    /// 综合推荐
    case recommended = 1
    
    public var title: String {
        switch self {
        case .latest:
            return "最新"
        case .recommended:
            return "最热"
        }
    }
}

//MARK: - 教材类型
/// 教材类型
public enum SDBookType: Int, Codable, Equatable {
    /// 数字教材
    case digital = 10
    /// 纸制教材
    case paper = 20
    /// PDF教材
    case pdf = 30
}



/// 图书搜索结果
public typealias SDBookSearchResult = SDPageResponse<SDResponseBookInfo>

// MARK: - Mock数据
extension SDBookSearchResult {
    static var mock: Self {
        return try! JSONDecoder().decode(Self.self, from: jsonModel.data(using: .utf8)!)
    }
    static var jsonModel: String {
        """
{
    "currentPage": 1,
    "offset": 1,
    "pageSize": 10,
    "realSize": 30,
    "total": 30,
    "totalPage": 3,
    "rows": [
        {
            "authorList": [
                {
                    "dbookId": 1,
                    "id": 1,
                    "memo": "主编",
                    "name": "张三",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
            "id": 1,
            "introduction": "这是一本关于Swift编程的教材，详细介绍了Swift语言的基础知识和高级特性。",
            "name": "Swift编程实战",
            "sellPrice": 59.9,
            "isbn": "9787111111111"
        },
        {
            "authorList": [
                {
                    "dbookId": 2,
                    "id": 2,
                    "memo": "主编",
                    "name": "李四",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
            "id": 2,
            "introduction": "深入浅出地讲解iOS开发的核心概念和实践技巧。",
            "name": "iOS开发指南",
            "sellPrice": 69.9,
            "isbn": "9787222222222"
        },
        {
            "authorList": [
                {
                    "dbookId": 3,
                    "id": 3,
                    "memo": "主编",
                    "name": "王五",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
            "id": 3,
            "introduction": "全面介绍SwiftUI框架的使用方法和最佳实践。",
            "name": "SwiftUI实战指南",
            "sellPrice": 79.9,
            "isbn": "9787333333333"
        },
        {
            "authorList": [
                {
                    "dbookId": 4,
                    "id": 4,
                    "memo": "主编",
                    "name": "赵六",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815828.png",
            "id": 4,
            "introduction": "探索iOS应用架构设计的最佳实践和模式。",
            "name": "iOS架构设计实践",
            "sellPrice": 88.0,
            "isbn": "9787444444444"
        },
        {
            "authorList": [
                {
                    "dbookId": 5,
                    "id": 5,
                    "memo": "主编",
                    "name": "钱七",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815829.png",
            "id": 5,
            "introduction": "深入理解Core Data框架，掌握数据持久化技术。",
            "name": "Core Data深度解析",
            "sellPrice": 75.0,
            "isbn": "9787555555555"
        },
        {
            "authorList": [
                {
                    "dbookId": 6,
                    "id": 6,
                    "memo": "主编",
                    "name": "孙八",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815830.png",
            "id": 6,
            "introduction": "掌握Swift并发编程，提高应用性能。",
            "name": "Swift并发编程指南",
            "sellPrice": 82.0,
            "isbn": "9787666666666"
        },
        {
            "authorList": [
                {
                    "dbookId": 7,
                    "id": 7,
                    "memo": "主编",
                    "name": "周九",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815831.png",
            "id": 7,
            "introduction": "学习iOS动画编程，创造流畅的用户体验。",
            "name": "iOS动画编程实战",
            "sellPrice": 72.0,
            "isbn": "9787777777777"
        },
        {
            "authorList": [
                {
                    "dbookId": 8,
                    "id": 8,
                    "memo": "主编",
                    "name": "吴十",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815832.png",
            "id": 8,
            "introduction": "深入理解Metal框架，掌握GPU编程技术。",
            "name": "Metal图形编程指南",
            "sellPrice": 92.0,
            "isbn": "9787888888888"
        },
        {
            "authorList": [
                {
                    "dbookId": 9,
                    "id": 9,
                    "memo": "主编",
                    "name": "郑十一",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815833.png",
            "id": 9,
            "introduction": "掌握iOS网络编程，构建高效的网络应用。",
            "name": "iOS网络编程实践",
            "sellPrice": 78.0,
            "isbn": "9787999999999"
        },
        {
            "authorList": [
                {
                    "dbookId": 10,
                    "id": 10,
                    "memo": "主编",
                    "name": "王十二",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815834.png",
            "id": 10,
            "introduction": "学习ARKit开发，创造增强现实应用。",
            "name": "ARKit开发教程",
            "sellPrice": 86.0,
            "isbn": "9787000000001"
        },
        {
            "authorList": [
                {
                    "dbookId": 11,
                    "id": 11,
                    "memo": "主编",
                    "name": "李十三",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815835.png",
            "id": 11,
            "introduction": "深入学习Core ML，实现机器学习应用。",
            "name": "Core ML实战指南",
            "sellPrice": 89.0,
            "isbn": "9787000000002"
        },
        {
            "authorList": [
                {
                    "dbookId": 12,
                    "id": 12,
                    "memo": "主编",
                    "name": "张十四",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815836.png",
            "id": 12,
            "introduction": "掌握iOS测试技术，提高代码质量。",
            "name": "iOS测试实践指南",
            "sellPrice": 76.0,
            "isbn": "9787000000003"
        },
        {
            "authorList": [
                {
                    "dbookId": 13,
                    "id": 13,
                    "memo": "主编",
                    "name": "刘十五",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815837.png",
            "id": 13,
            "introduction": "学习Core Audio，开发音频应用程序。",
            "name": "iOS音频编程指南",
            "sellPrice": 83.0,
            "isbn": "9787000000004"
        },
        {
            "authorList": [
                {
                    "dbookId": 14,
                    "id": 14,
                    "memo": "主编",
                    "name": "陈十六",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815838.png",
            "id": 14,
            "introduction": "深入理解iOS安全机制，保护应用数据。",
            "name": "iOS安全编程实战",
            "sellPrice": 85.0,
            "isbn": "9787000000005"
        },
        {
            "authorList": [
                {
                    "dbookId": 15,
                    "id": 15,
                    "memo": "主编",
                    "name": "杨十七",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815839.png",
            "id": 15,
            "introduction": "掌握StoreKit框架，实现应用内购买功能。",
            "name": "iOS应用内购买指南",
            "sellPrice": 77.0,
            "isbn": "9787000000006"
        },
        {
            "authorList": [
                {
                    "dbookId": 16,
                    "id": 16,
                    "memo": "主编",
                    "name": "黄十八",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815840.png",
            "id": 16,
            "introduction": "学习Core Location和MapKit，开发位置服务应用。",
            "name": "iOS地图与定位开发",
            "sellPrice": 81.0,
            "isbn": "9787000000007"
        },
        {
            "authorList": [
                {
                    "dbookId": 17,
                    "id": 17,
                    "memo": "主编",
                    "name": "周十九",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815841.png",
            "id": 17,
            "introduction": "深入学习Core Image，实现图像处理功能。",
            "name": "iOS图像处理教程",
            "sellPrice": 84.0,
            "isbn": "9787000000008"
        },
        {
            "authorList": [
                {
                    "dbookId": 18,
                    "id": 18,
                    "memo": "主编",
                    "name": "吴二十",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815842.png",
            "id": 18,
            "introduction": "掌握Xcode开发工具的高级用法。",
            "name": "Xcode高级开发指南",
            "sellPrice": 73.0,
            "isbn": "9787000000009"
        },
        {
            "authorList": [
                {
                    "dbookId": 19,
                    "id": 19,
                    "memo": "主编",
                    "name": "郑二一",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815843.png",
            "id": 19,
            "introduction": "学习iOS应用性能优化技术。",
            "name": "iOS性能优化实战",
            "sellPrice": 87.0,
            "isbn": "9787000000010"
        },
        {
            "authorList": [
                {
                    "dbookId": 20,
                    "id": 20,
                    "memo": "主编",
                    "name": "李二二",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815844.png",
            "id": 20,
            "introduction": "深入理解iOS多线程编程技术。",
            "name": "iOS多线程编程指南",
            "sellPrice": 82.0,
            "isbn": "9787000000011"
        },
        {
            "authorList": [
                {
                    "dbookId": 21,
                    "id": 21,
                    "memo": "主编",
                    "name": "张二三",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815845.png",
            "id": 21,
            "introduction": "掌握iOS应用调试和错误处理技术。",
            "name": "iOS调试与错误处理",
            "sellPrice": 78.0,
            "isbn": "9787000000012"
        },
        {
            "authorList": [
                {
                    "dbookId": 22,
                    "id": 22,
                    "memo": "主编",
                    "name": "王二四",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815846.png",
            "id": 22,
            "introduction": "深入理解iOS应用国际化和本地化技术。",
            "name": "iOS国际化开发指南",
            "sellPrice": 76.0,
            "isbn": "9787000000013"
        },
        {
            "authorList": [
                {
                    "dbookId": 23,
                    "id": 23,
                    "memo": "主编",
                    "name": "李二五",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815847.png",
            "id": 23,
            "introduction": "掌握iOS应用签名和发布流程。",
            "name": "iOS应用发布实践",
            "sellPrice": 72.0,
            "isbn": "9787000000014"
        },
        {
            "authorList": [
                {
                    "dbookId": 24,
                    "id": 24,
                    "memo": "主编",
                    "name": "赵二六",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815848.png",
            "id": 24,
            "introduction": "学习iOS应用的持续集成和部署技术。",
            "name": "iOS持续集成与部署",
            "sellPrice": 85.0,
            "isbn": "9787000000015"
        },
        {
            "authorList": [
                {
                    "dbookId": 25,
                    "id": 25,
                    "memo": "主编",
                    "name": "钱二七",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815849.png",
            "id": 25,
            "introduction": "深入学习iOS应用架构模式和设计原则。",
            "name": "iOS架构模式精解",
            "sellPrice": 88.0,
            "isbn": "9787000000016"
        },
        {
            "authorList": [
                {
                    "dbookId": 26,
                    "id": 26,
                    "memo": "主编",
                    "name": "孙二八",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815850.png",
            "id": 26,
            "introduction": "掌握iOS应用数据加密和安全存储技术。",
            "name": "iOS数据安全指南",
            "sellPrice": 82.0,
            "isbn": "9787000000017"
        },
        {
            "authorList": [
                {
                    "dbookId": 27,
                    "id": 27,
                    "memo": "主编",
                    "name": "周二九",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815851.png",
            "id": 27,
            "introduction": "学习iOS应用的代码重构和优化技术。",
            "name": "iOS重构与优化实践",
            "sellPrice": 79.0,
            "isbn": "9787000000018"
        },
        {
            "authorList": [
                {
                    "dbookId": 28,
                    "id": 28,
                    "memo": "主编",
                    "name": "吴三十",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815852.png",
            "id": 28,
            "introduction": "深入理解iOS应用的内存管理机制。",
            "name": "iOS内存管理详解",
            "sellPrice": 76.0,
            "isbn": "9787000000019"
        },
        {
            "authorList": [
                {
                    "dbookId": 29,
                    "id": 29,
                    "memo": "主编",
                    "name": "郑三一",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815853.png",
            "id": 29,
            "introduction": "掌握iOS应用的用户体验设计原则。",
            "name": "iOS用户体验设计",
            "sellPrice": 84.0,
            "isbn": "9787000000020"
        },
        {
            "authorList": [
                {
                    "dbookId": 30,
                    "id": 30,
                    "memo": "主编",
                    "name": "王三二",
                    "typeName": "主编"
                }
            ],
            "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815854.png",
            "id": 30,
            "introduction": "学习iOS应用的设计模式和最佳实践。",
            "name": "iOS设计模式精讲",
            "sellPrice": 86.0,
            "isbn": "9787000000021"
        }
    ]
}
"""
    }
}
