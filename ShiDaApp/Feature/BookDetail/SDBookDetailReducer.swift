//
//  SDBookDetailReducer.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SDBookDetailReducer {
    @ObservableState
    struct State: Equatable {
        let id: Int
    }
    
  
    
    enum View {
        case onAppear
    }
    
    enum Action: ViewAction {
        case view(View)
        }

    enum Path: Equatable {
        case onAppear    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    return .none
                }
         
            }
        }
    }
}
