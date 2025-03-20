import Foundation
import ComposableArchitecture
import Moya

/// 扩展依赖值以包含首页客户端
extension DependencyValues {
    var homeClient: SDHomeClient {
        get { self[SDHomeClient.self] }
        set { self[SDHomeClient.self] = newValue }
    }
}

/// 首页相关的客户端接口
struct SDHomeClient {
    /// 获取首页栏目列表
    var getSectionList: @Sendable () async throws -> [SDResponseHomeSection]
    /// 获取栏目详情书籍列表
    var getSectionDetailBookList: @Sendable (Int) async throws -> [SDResponseBookInfo]
    /// 获取栏目详情合作院校列表
    var getSectionDetailSchoolList: @Sendable (Int) async throws -> [SDResponseHomeSectionSchool]
    /// 获取学校图书列表
    var getSchoolBookList: @Sendable (Int) async throws -> [SDResponseBookInfo]
}

extension SDHomeClient: DependencyKey {
    /// 提供实际的首页客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getSectionList: {
                try await apiService.requestResult(SDHomeEndpoint.sectionList)
            },
            getSectionDetailBookList: { sectionId in
                try await apiService.requestResult(SDHomeEndpoint.sectionDetailBookList(sectionId: sectionId))
            },
            getSectionDetailSchoolList: { sectionId in
                try await apiService.requestResult(SDHomeEndpoint.sectionDetailSchoolList(sectionId: sectionId))
            },
            getSchoolBookList: { schoolId in
                try await apiService.requestResult(SDHomeEndpoint.schoolBookList(schoolId: schoolId))
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getSectionList: {
                // 使用SDResponseHomeSection的mockArray数据
                return SDResponseHomeSection.mockArray
            },
            getSectionDetailBookList: { _ in
                // 使用SDResponseBookInfo的mockArray数据
                return SDResponseBookInfo.mockArray
            },
            getSectionDetailSchoolList: { _ in
                // 使用SDResponseHomeSectionSchool的mockArray数据
                return SDResponseHomeSectionSchool.mockArray
            },
            getSchoolBookList: { _ in
                // 使用SDResponseBookInfo的mockArray数据
                return SDResponseBookInfo.mockArray
            }
        )
    }
    
    static var previewValue: SDHomeClient {
        testValue
    }
}
