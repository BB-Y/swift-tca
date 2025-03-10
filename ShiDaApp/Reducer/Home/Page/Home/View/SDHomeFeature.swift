//
//  SDHomeFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct SDHomeFeature {
    
    @ObservableState
    struct State: Equatable {
        
        
        // 首页的状态
        var homeData: [SDResponseHomeSection]?

        var path: StackState<Path.State> = StackState<Path.State>()

        var isLoginViewShow = false
        
        @Shared(.shareUserToken) var token: String? = nil

        @Shared(.shareLoginStatus) var loginStatus = .notLogin
    }
    
    @Reducer(state: .equatable)
    enum Path {
        
      case test(SDHomeTestFeature)
      
    }
    
    enum Action {
        // 首页的动作
        case onAppear
        case fetchHomeDataResponse(Result<[SDResponseHomeSection], Error>)
        case pushToTestView
        case path(StackActionOf<Path>)

        case onLoginTapped
        // 添加新的 Action
        case onSectionItemTapped(SDResponseHomeListItem)
        case onSectionTitleTapped(SDResponseHomeSection)
    }
    enum CancelID: Hashable {
        case loginStatusObservation
    }
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.mainQueue) var main
    @Dependency(\.homeClient) var homeClient  // 新增
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { send in
                    await send(.fetchHomeDataResponse(
                        Result { try await homeClient.getSectionList() }
                    ))
                }
                
            case let .fetchHomeDataResponse(.success(sections)):
                state.homeData = sections
                return .none
                
            case .fetchHomeDataResponse(.failure):
                // 处理错误情况
                return .none
                
//                return .publisher {
//                    state.$loginStatus.publisher
//                        .map { status in
//                            
//                            return Action.onLoginStatusChanged
//                        }
//                        .receive(on: main)
//                }

           
            case .pushToTestView:
                state.path.append(.test(SDHomeTestFeature.State(page: "1")))
                return .none
                    
                //父级处理
            case .onLoginTapped:
                return .none
                
            case .path(.element(id: _, action: .test(.delegate(.nextPage(let page))))):
                
                state.path.append(.test(SDHomeTestFeature.State(page: page)))
                return .none
            case .path(.element(id: _, action: .test(.delegate(.pop)))):
                state.path.popLast()
                return .none
            case .path(.element(id: _, action: .test(.delegate(.popToRoot)))):
                
                state.path.removeAll()
                return .none
                
            case .path(_):
                return .none
            case let .onSectionItemTapped(item):
                // 根据点击的项目类型进行不同处理
                switch item.dataType {
                case .textbook:
                    // 处理书籍点击，例如导航到书籍详情页
                    print("点击了书籍: \(item.dataName ?? "")")
                    return .none
                case .cooperativeSchool:
                    // 处理学校点击
                    print("点击了学校: \(item.dataName ?? "")")
                    return .none
                default:
                    print("点击了其他类型项目: \(item.dataName ?? "")")
                    return .none
                }
                
            case let .onSectionTitleTapped(section):
                // 处理分区标题点击，例如导航到分区更多内容页面
                print("点击了分区标题: \(section.name ?? "")")
                return .none
                
            }
        }
        .forEach(\.path, action: \.path)
    }
}


