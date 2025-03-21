//
//  SDBookReaderModel.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//
import Foundation
import CodableWrappers


//章节内容信息
@CustomCodable
struct SDChapterDetailModel: Codable, Identifiable, Equatable {
    let id: Int
    let articleNumber : Int
    let chapterId : Int
    let content : String?
    let dbookId : Int
    let versionNumber : Int
}
extension SDChapterDetailModel: SDMockable {
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
