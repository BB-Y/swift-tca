//
//  SDBookDetailView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SDBookDetailReducer.self)
struct SDBookDetailView: View {
    @Perception.Bindable var store: StoreOf<SDBookDetailReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("图书id: \(store.id)")
            }
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    SDBookDetailView(
        store: Store(
            initialState: SDBookDetailReducer.State(id: 11),
            reducer: { SDBookDetailReducer() }
        )
    )
}
