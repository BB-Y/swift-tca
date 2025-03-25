//
//  SDStudyClient.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/7.
//

import Foundation
import ComposableArchitecture
import Moya

/// 学习相关的客户端接口
struct SDStudyClient {
    /// 获取教师用书页面列表
    var getTeacherBookPageList: @Sendable (_ pagination: SDPagination) async throws -> SDTeacherBookPageResult
}

extension SDStudyClient: DependencyKey {
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getTeacherBookPageList: { pagination in
                try await apiService.requestResult(SDStudyEndpoint.getTeacherBookPageList(pagination: pagination))
            }
        )
    }
    
    static var testValue: Self {
        Self(
            getTeacherBookPageList: { pagination in
                // 模拟获取教师用书列表成功
                // 创建测试用的班级信息
                let classInfo1 = SDClassInfoDto(
                    classId: 1,
                    className: "高一(1)班",
                    teacher: "李老师",
                    teacherUserId: 101
                )
                
                let classInfo2 = SDClassInfoDto(
                    classId: 2,
                    className: "高一(2)班",
                    teacher: "王老师",
                    teacherUserId: 102
                )
                
                // 创建测试用的教师用书信息
                let book1 = SDStudyMyDbookDto(
                    authors: "张三",
                    categoryName: "语文",
                    classInfo: classInfo1,
                    dbookCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
                    dbookId: 1,
                    dbookName: "高中语文教师用书",
                    id: 1,
                    publisher: "人民教育出版社",
                    status: 1
                )
                
                let book2 = SDStudyMyDbookDto(
                    authors: "李四",
                    categoryName: "数学",
                    classInfo: classInfo2,
                    dbookCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                    dbookId: 2,
                    dbookName: "高中数学教师用书",
                    id: 2,
                    publisher: "人民教育出版社",
                    status: 1
                )
                
                // 创建分页响应
                return SDPageResponse(
                    currentPage: pagination.offset,
                    offset: pagination.offset,
                    pageSize: pagination.pageSize,
                    realSize: 2,
                    rows: [book1, book2],
                    total: 2,
                    totalPage: 1
                )
            }
        )
    }
    
    static var previewValue: SDStudyClient {
        testValue
    }
}

extension DependencyValues {
    var studyClient: SDStudyClient {
        get { self[SDStudyClient.self] }
        set { self[SDStudyClient.self] = newValue }
    }
}