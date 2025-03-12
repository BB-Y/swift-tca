import Foundation
import Moya

/// 首页相关的 API 端点
enum SDHomeEndpoint {
    /// 获取首页栏目列表
    case sectionList
    /// 获取栏目详情书籍列表
    case sectionDetailBookList(sectionId: Int)
    /// 获取栏目详情合作院校列表
    case sectionDetailSchoolList(sectionId: Int)
    /// 获取学校图书列表
    case schoolBookList(schoolId: Int)
}

extension SDHomeEndpoint: SDEndpoint {
    
    public var path: String {
        switch self {
        case .sectionList:                  return "/app/homepage/sectionlist"
        case .sectionDetailBookList:        return "/app/homepage/sectiondetail/booklist"
        case .sectionDetailSchoolList:      return "/app/homepage/sectiondetail/schoollist"
        case .schoolBookList:               return "/app/homepage/school/book/list"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sectionList:                  return .get
        case .sectionDetailBookList:        return .get
        case .sectionDetailSchoolList:      return .get
        case .schoolBookList:               return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .sectionList:
            return .requestPlain
        case .sectionDetailBookList(let sectionId):
            return .requestParameters(
                parameters: ["sectionid": sectionId],
                encoding: URLEncoding.queryString
            )
        case .sectionDetailSchoolList(let sectionId):
            return .requestParameters(
                parameters: ["sectionid": sectionId],
                encoding: URLEncoding.queryString
            )
        case .schoolBookList(let schoolId):
            return .requestParameters(
                parameters: ["schoolId": schoolId],
                encoding: URLEncoding.queryString
            )
        }
    }
}
