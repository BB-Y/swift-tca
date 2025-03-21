//
//  SDBookReaderEndpoint.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//

import Foundation
import Moya

/// 图书相关的 API 端点
enum SDBookReaderEndpoint {
    /// 获取图书详情
    case chapterDetail(id: Int)
}
extension SDBookReaderEndpoint: SDEndpoint {
    public var path: String {
        switch self {
        case let .chapterDetail(id):
            return "dbook/reader/read/article/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .chapterDetail:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .chapterDetail:
            // 由于ID已经包含在路径中，这里不需要查询参数
            return .requestPlain
        }
    }
}
