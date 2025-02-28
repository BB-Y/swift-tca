//
//  SDBookView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

struct BookFeature: Reducer {
    struct State: Equatable {
        // 书籍页面的状态
    }
    
    enum Action: Equatable {
        // 书籍页面的动作
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

struct BookView: View {
    let store: StoreOf<BookFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("书籍")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                List {
                    ForEach(1...5, id: \.self) { index in
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.blue)
                            
                            Text("书籍 \(index)")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    BookView(
        store: Store(
            initialState: BookFeature.State(),
            reducer: { BookFeature() }
        )
    )
}