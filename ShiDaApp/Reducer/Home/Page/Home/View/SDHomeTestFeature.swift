//
//  SDHomeTestFeature.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/2.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SDHomeTestFeature {
    
    
    @ObservableState
    struct State: Equatable {
        var page: String

    }
    
    
    enum Action {
        case onAppear
        case nextViewTapped
        case popToRootTapped
        case onPopTapped
        
        
        
        case delegate(Delegate)
        enum Delegate {
            case popToRoot
            case nextPage(String)
            case pop
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .nextViewTapped:
                if let page = Int(state.page) {
                   let newPage = page + 1
                    return .send(.delegate(.nextPage("\(newPage)")))

                }
                return .none

                

                
            case .onPopTapped:
                return .send(.delegate(.pop))
            
            case .popToRootTapped:
                return .send(.delegate(.popToRoot))
            case .delegate:
              return .none
            }
        }
        

        
    }
}
