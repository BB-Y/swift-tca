//
//  SDMyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

struct MyFeature: Reducer {
    struct State: Equatable {
        // 我的页面的状态
        @Shared(.shareUserToken) var token = ""
    }
    
    enum Action: Equatable,ViewAction {
        // 我的页面的动作
        case onAppear
        
        
        case view(View)
        enum View {
            case onLogoutTapped

        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 处理页面出现时的逻辑
                return .none
            case let .view(viewAction):
                switch viewAction {
                case .onLogoutTapped:
                    state.$token.withLock({$0 = ""})
                }
                return .none
            }
        }
    }
}

@ViewAction(for: MyFeature.self)
struct MyView: View {
    @Perception.Bindable var store: StoreOf<MyFeature>
    
    var body: some View {
        VStack {
            Text("个人中心")
                .font(.largeTitle)
                .fontWeight(.bold)
            Button("退出登陆") {
                send(.onLogoutTapped)
            }
            Spacer()
            
            VStack(spacing: 20) {
                // 用户信息
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("用户名")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("用户ID: 123456")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 菜单项
                List {
                    ForEach(["我的学习", "我的收藏", "学习记录", "设置"], id: \.self) { item in
                        HStack {
                            Text(item)
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: 250)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    MyView(
        store: Store(
            initialState: MyFeature.State(),
            reducer: { MyFeature() }
        )
    )
}
