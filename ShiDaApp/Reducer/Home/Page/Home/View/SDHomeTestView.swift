//
//  SDHomeTestView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/2.
//

import SwiftUI
import ComposableArchitecture

struct SDHomeTestView: View {
    @Perception.Bindable var store: StoreOf<SDHomeTestFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("测试页面: \(store.page)")
                    .font(.title)
                    .padding()
                
                /// When someone activates the navigation link that this initializer creates, SwiftUI looks for
                /// a parent `NavigationStack` view with a store of ``StackState`` containing elements that
                /// matches the type of this initializer's `state` input.
                NavigationLink("NavigationLink", state: SDHomeFeature.Path.State.test(SDHomeTestFeature.State(page: "1000000")))
                
               
                Button("返回上一级") {
                    store.send(.onPopTapped)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                Button("Push下一级") {
                    store.send(.nextViewTapped)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // 添加返回首页按钮
                Button("返回首页") {
                    store.send(.popToRootTapped)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            .navigationTitle("测试页面")
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    SDHomeTestView(
        store: Store(
            initialState: SDHomeTestFeature.State(page: "1"),
            reducer: { SDHomeTestFeature() }
        )
    )

    
}
