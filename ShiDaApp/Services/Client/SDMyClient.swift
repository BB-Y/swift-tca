//
//  MyClient.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/20.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Moya

struct SDMyClient {
    var getFavoritesList: @Sendable(_ params: SDReqParaMyCollection) async throws -> SDBookSearchResult
    var searchFavoritesList: @Sendable (_ params: SDReqParaMyCollection) async throws -> SDBookSearchResult
    var getCorrectionList: @Sendable (_ pagination: SDPagination) async throws -> SDCorrectionListResult
    var getUnreadMessageCount: @Sendable () async throws -> Int
}

extension SDMyClient: DependencyKey {
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getFavoritesList: {params in 
                try await apiService.requestResult(SDUserEndpoint.getMyCollections(params: params))
            },
            searchFavoritesList: { params in
                try await apiService.requestResult(SDUserEndpoint.getMyCollections(params: params))
            },
            getCorrectionList: { pagination in
                try await apiService.requestResult(SDUserEndpoint.getMyCorrections(pagination: pagination))
            },
            getUnreadMessageCount: {
                try await apiService.requestResult(SDUserEndpoint.getUnreadMessageCount)
            }
        )
    }
    
    static var previewValue: Self {
        return Self(
            getFavoritesList: {params in 
                return SDBookSearchResult.mock
            },
            searchFavoritesList: { _ in
                return SDBookSearchResult.mock
            },
            getCorrectionList: { _ in
                return SDCorrectionListResult.mock
            },
            getUnreadMessageCount: {
                return 5
            }
        )
    }
    
    static var testValue: Self {
        return previewValue
    }
}

extension DependencyValues {
    var myClient: SDMyClient {
        get { self[SDMyClient.self] }
        set { self[SDMyClient.self] = newValue }
    }
}
