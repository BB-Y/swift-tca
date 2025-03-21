//
//  SDBookReaderClient.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//
import Foundation
import ComposableArchitecture
import Moya


extension DependencyValues {
    var bookReaderClient: SDBookReaderClient {
        get { self[SDBookReaderClient.self] }
        set { self[SDBookReaderClient.self] = newValue }
    }
}
/// 图书相关的客户端接口
struct SDBookReaderClient {
    /// 获取图书详情
    var fetchChapterDetail: @Sendable (Int) async throws -> SDChapterDetailModel

}

extension SDBookReaderClient: DependencyKey {
    /// 提供实际的图书客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            fetchChapterDetail: { id in
                try await apiService.requestResult(SDBookReaderEndpoint.chapterDetail(id: id))
            }
        )
    }
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            fetchChapterDetail: { _ in
                return SDChapterDetailModel.mock
            }
        )
    }
    
    static var previewValue: SDBookReaderClient {
        testValue
    }
}
