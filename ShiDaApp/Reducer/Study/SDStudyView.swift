//
//  SDStudyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

struct StudyFeature: Reducer {
    struct State: Equatable {
        // 学习页面的状态
    }
    
    enum Action: Equatable {
        // 学习页面的动作
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 处理页面出现时的逻辑
                return .none
            }
        }
    }
}

struct StudyView: View {
    let store: StoreOf<StudyFeature>
    
    var body: some View {
        WithPerceptionTracking{
            Text("study")

        }
    }
}

#Preview {
    StudyView(
        store: Store(
            initialState: StudyFeature.State(),
            reducer: { StudyFeature() }
        )
    )
}
