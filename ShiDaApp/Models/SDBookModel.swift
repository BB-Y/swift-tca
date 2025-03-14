import Foundation
import CodableWrappers
/// 图书分类模型
struct SDBookCategory: Codable, Identifiable, Equatable {
    let createTime: String?
    let id: Int?
    let level: Int?
    let name: String?
    let parentId: Int?
    let subList: [SDBookCategory]?
}

extension SDBookCategory: SDMockable {
    static var jsonModel: String {
        """
{
    "createTime": "2025-03-10",
    "id": 1,
    "level": 1,
    "name": "文学",
    "parentId": 0,
    "subList": [
        {
            "createTime": "2025-03-10",
            "id": 2,
            "level": 2,
            "name": "小说",
            "parentId": 1,
            "subList": null
        },
        {
            "createTime": "2025-03-10",
            "id": 3,
            "level": 2,
            "name": "诗歌",
            "parentId": 1,
            "subList": null
        }
    ]
}
"""
    }
    
    static var jsonArray: String {
        """
[
    {
        "createTime": "2025-03-10",
        "id": 1,
        "level": 1,
        "name": "文学",
        "parentId": 0,
        "subList": [
            {
                "createTime": "2025-03-10",
                "id": 2,
                "level": 2,
                "name": "小说",
                "parentId": 1,
                "subList": null
            },
            {
                "createTime": "2025-03-10",
                "id": 3,
                "level": 2,
                "name": "诗歌",
                "parentId": 1,
                "subList": null
            }
        ]
    },
    {
        "createTime": "2025-03-10",
        "id": 4,
        "level": 1,
        "name": "科学",
        "parentId": 0,
        "subList": [
            {
                "createTime": "2025-03-10",
                "id": 5,
                "level": 2,
                "name": "物理",
                "parentId": 4,
                "subList": null
            },
            {
                "createTime": "2025-03-10",
                "id": 6,
                "level": 2,
                "name": "化学",
                "parentId": 4,
                "subList": null
            }
        ]
    },
    {
        "createTime": "2025-03-10",
        "id": 7,
        "level": 1,
        "name": "计算机",
        "parentId": 0,
        "subList": [
            {
                "createTime": "2025-03-10",
                "id": 8,
                "level": 2,
                "name": "编程语言",
                "parentId": 7,
                "subList": null
            },
            {
                "createTime": "2025-03-10",
                "id": 11,
                "level": 2,
                "name": "数据库",
                "parentId": 7,
                "subList": null
            }
        ]
    }
]
"""
    }
}


    

/// 图书详情模型SDBookDetail
@CustomCodable
struct SDBookDetailModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let cover: String?
    let introduction: String?
    let recommended: String?
    let isbn: String?
    let publisher: String?
    
    @CodingUses<TimestampStringCoder>
    var publishDatetime: String
    let cooperation: String?
    let fileUrl: String?
    let qrcodeUrl: String?
    let sellPrice: Double?
    let categoryId: Int?
    let webzipFileId: Int?
    let webzipFileName: String?
    let webzipFileUrl: String?
    
    // 枚举替代整数状态
    let publishStatus: PublishStatus?
    
    // 布尔值状态
    let isActived: Bool?
    
    @CustomCodingKey("isCollection")
    let isFavorite: Bool?  // 注意：API中是isCollection，这里改为更符合Swift命名规范的isFavorite
    let isRequest: Bool?
    
    // 关联数据
    let authorList: [SDResponseBookCopyrightTeam]?
    let catalogList: [SDBookChapter]?
    
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
    
    /// 出版状态枚举
    enum PublishStatus: Int, Codable, Equatable {
        case notPublished = 10  // 未上架
        case published = 20     // 已上架
        case removed = 30       // 已下架
        
        var description: String {
            switch self {
            case .notPublished: return "未上架"
            case .published: return "已上架"
            case .removed: return "已下架"
            }
        }
    }
}

/// 图书章节模型
struct SDBookChapter: Codable, Identifiable, Equatable {
    let id: Int?
    let chapterId: Int?
    let dbookId: Int?
    let name: String?
    let parentId: Int?
    let level: Int?
    let displaySeq: Int?
    let fullSeq: String?
    let treePath: String?
    let linkType: LinkType?
    let linkUrl: String?
    let linkArticleId: Int?
    let linkArticleNumber: Int?
    let resourceCount: Int?
    let versionNumber: Int?
    let createDatetime: String?
    let createUserId: Int?
    let modifyDatetime: String?
    let modifyUserId: Int?
    let tryReadFlag: Bool?
    let childs: [SDBookChapter]?
    
    /// 链接类型枚举
    enum LinkType: Int, Codable, Equatable {
        case none = 0       // 无链接
        case internalLink = 10  // 内部链接
        case externalLink = 20  // 外部链接
        // 可根据实际需求添加更多类型
    }
}

// MARK: - Mock 数据支持
extension SDBookDetailModel: SDMockable {
    static var jsonModel: String {
        """
{
    "id": 1,
    "name": "Swift编程实战",
    "cover": "https://example.com/covers/swift.jpg",
    "introduction": "这是一本关于Swift编程的实用教材，适合初学者和有一定基础的开发者。",
    "recommended": "推荐给所有iOS开发者",
    "isbn": "978-7-XXXX-XXXX-X",
    "publisher": "编程出版社",
    "publishDatetime": 1111122222,
    "cooperation": "某知名科技大学",
    "fileUrl": "https://example.com/books/swift.pdf",
    "qrcodeUrl": "https://example.com/qrcodes/swift.png",
    "sellPrice": 99.00,
    "categoryId": 8,
    "publishStatus": 20,
    "isActived": true,
    "isCollection": false,
    "isRequest": false,
    "webzipFileId": 123,
    "webzipFileName": "swift_magazine.zip",
    "webzipFileUrl": "https://example.com/webzips/swift_magazine.zip",
    "authorList": [
        {
            "id": 1,
            "dbookId": 1,
            "name": "张三",
            "typeName": "作者",
            "memo": "资深iOS开发者",
            "createTime": "2025-01-10",
            "createUserId": 100
        },
        {
            "id": 2,
            "dbookId": 1,
            "name": "李四",
            "typeName": "编辑",
            "memo": "技术图书编辑",
            "createTime": "2025-01-10",
            "createUserId": 101
        }
    ],
    "catalogList": [
        {
            "id": 1,
            "chapterId": 1,
            "dbookId": 1,
            "name": "Swift基础",
            "parentId": 0,
            "level": 1,
            "displaySeq": 1,
            "fullSeq": "1",
            "treePath": "/1",
            "linkType": 0,
            "resourceCount": 5,
            "tryReadFlag": true,
            "childs": [
                {
                    "id": 2,
                    "chapterId": 2,
                    "dbookId": 1,
                    "name": "变量和常量",
                    "parentId": 1,
                    "level": 2,
                    "displaySeq": 1,
                    "fullSeq": "1.1",
                    "treePath": "/1/2",
                    "linkType": 10,
                    "linkArticleId": 101,
                    "resourceCount": 2,
                    "tryReadFlag": true,
                    "childs": []
                },
                {
                    "id": 3,
                    "chapterId": 3,
                    "dbookId": 1,
                    "name": "基本数据类型",
                    "parentId": 1,
                    "level": 2,
                    "displaySeq": 2,
                    "fullSeq": "1.2",
                    "treePath": "/1/3",
                    "linkType": 10,
                    "linkArticleId": 102,
                    "resourceCount": 3,
                    "tryReadFlag": false,
                    "childs": []
                }
            ]
        },
        {
            "id": 4,
            "chapterId": 4,
            "dbookId": 1,
            "name": "函数和闭包",
            "parentId": 0,
            "level": 1,
            "displaySeq": 2,
            "fullSeq": "2",
            "treePath": "/4",
            "linkType": 0,
            "resourceCount": 4,
            "tryReadFlag": false,
            "childs": []
        }
    ]
}
"""
    }
}
