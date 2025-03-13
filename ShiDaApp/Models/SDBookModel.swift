import Foundation

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