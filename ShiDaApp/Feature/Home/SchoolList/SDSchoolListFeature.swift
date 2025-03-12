//
//  SDSchoolListFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDSchoolListFeature {
    
    @ObservableState
    struct State: Equatable {
        // 栏目ID
        let sectionId: Int
        // 栏目标题
        let sectionTitle: String
        // 院校列表数据
        var schoolList: [SDResponseHomeSectionSchool]?
        // 是否正在加载
        var isLoading: Bool = false
        // 是否出现错误
        var hasError: Bool = false
        // 搜索文本
        var searchText: String = ""
        // 搜索结果
        var searchResults: [SDResponseHomeSectionSchool] = []
        // 是否正在搜索
        var isSearching: Bool = false
    }
    
    enum Action: BindableAction {
        // 页面出现
        case onAppear
        // 获取院校列表响应
        case fetchSchoolListResponse(Result<[SDResponseHomeSectionSchool], Error>)
        // 点击院校
        case onSchoolTapped(SDResponseHomeSectionSchool)
        // 执行搜索
        case performSearch
        // 搜索文本绑定
        case binding(BindingAction<State>)
    }
    
    enum CancelID: Hashable {
        case fetchSchoolList
        case searchDebounce
    }
    
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                // 开始加载
                state.isLoading = true
                state.hasError = false
                
                // 请求院校列表数据
                return .run { [sectionId = state.sectionId] send in
                    await send(.fetchSchoolListResponse(
                        Result { try await homeClient.getSectionDetailSchoolList(sectionId) }
                    ))
                }
                .cancellable(id: CancelID.fetchSchoolList)
                
            case let .fetchSchoolListResponse(.success(schools)):
                // 更新院校列表数据
                state.schoolList = schools
                state.isLoading = false
                
                // 如果有搜索文本，立即执行搜索
                if !state.searchText.isEmpty {
                    return .send(.performSearch)
                }
                return .none
                
            case .fetchSchoolListResponse(.failure):
                // 处理错误情况
                state.isLoading = false
                state.hasError = true
                return .none
                
            case .onSchoolTapped(_):
                // 处理院校点击事件，后续可以扩展为导航到院校详情
                return .none
                
            case .performSearch:
                guard let schools = state.schoolList else {
                    state.searchResults = []
                    state.isSearching = false
                    return .none
                }
                
                state.isSearching = false
                
                if state.searchText.isEmpty {
                    state.searchResults = []
                    return .none
                }
                
                // 执行搜索
                state.searchResults = schools.filter { school in
                    (school.name ?? "").localizedCaseInsensitiveContains(state.searchText) ||
                    (school.type ?? "").localizedCaseInsensitiveContains(state.searchText)
                }
                
                return .none
                
            case .binding(\.searchText):
                // 当搜索文本变化时，设置正在搜索状态
                state.isSearching = true
                
                // 使用节流来延迟搜索，避免频繁搜索
                return .run { send in
                    try await Task.sleep(for: .milliseconds(300))
                    await send(.performSearch)
                }
                .cancellable(id: CancelID.searchDebounce)
                
            case .binding(_):
                return .none
            }
        }
    }
}