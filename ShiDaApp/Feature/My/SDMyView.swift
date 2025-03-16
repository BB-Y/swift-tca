//
//  SDMyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyFeature {
    @ObservableState
    struct State: Equatable {
        
        var path: StackState<Path.State> = StackState<Path.State>()

        // 我的页面的状态
        @Shared(.shareLoginStatus) var loginStatus = .notLogin
        @Shared(.shareUserInfo) var userInfo = nil
        @Shared(.shareAcceptProtocol) var acceptProtocol = false
        @Shared(.shareUserToken) var token = nil

        @Presents var login: SDLoginHomeReducer.State?

        var userInfoModel: SDResponseLogin? {
            guard let data = userInfo else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
    }
    
    @Reducer(state: .equatable)
    enum Path {
        

      
    }
    
    
    enum View {
        case onAppear
        case onLogoutTapped
        case onRemoveUserTapped
    }
    
    enum Action: ViewAction {
        // 我的页面的动作
       
        
        case path(StackActionOf<Path>)

        case view(View)
        
        case login(PresentationAction<SDLoginHomeReducer.Action>)

        case logout
        
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .logout:
                return .none
            case let .view(viewAction):
                switch viewAction {
                case .onLogoutTapped:
                    state.$loginStatus.withLock({$0 = .logout})
                    state.$acceptProtocol.withLock({$0 = false})
                    state.path.removeAll()
                    state.login = SDLoginHomeReducer.State()
                    return .send(.logout)
                case .onRemoveUserTapped:
                    state.$loginStatus.withLock({$0 = .notLogin})
                    state.$userInfo.withLock({$0 = nil})
                    state.$acceptProtocol.withLock({$0 = false})
                    state.$token.withLock({$0 = ""})

                    state.path.removeAll()
                    state.login = SDLoginHomeReducer.State()
                    return .send(.logout)


                case .onAppear:
                    return .none

                }
                return .none
                
            case .login(_):
                return .none
                
            case .path:
                return .none

            }
        
        }
        .ifLet(\.$login, action: \.login) {
            SDLoginHomeReducer()
        }
        .forEach(\.path, action: \.path)

    }
}

@ViewAction(for: MyFeature.self)
struct MyView: View {
    @Perception.Bindable var store: StoreOf<MyFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("个人中心")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Button("退出登陆") {
                    send(.onLogoutTapped)
                }
                
                Button("退出登陆,清除用户信息") {
                    send(.onRemoveUserTapped)
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
                            
                            Text(store.userInfoModel?.phone ?? "")
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
                            WithPerceptionTracking {
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
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 250)
                }
                .padding()
                
                Spacer()
            }
        }
        
        .fullScreenCover(item: $store.scope(state: \.login, action: \.login), content: { item in
            WithPerceptionTracking {
                SDLoginHomeView(store: item)
            }
        })
        .onAppear {
            send(.onAppear)
        }
    }
}


@available(iOS 18.0, *)
#Preview {
        
    @Previewable @State var store = Store(
            initialState: MyFeature.State(),
            reducer: { MyFeature() }
        )
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        MyView(
            store: Store(
                initialState: MyFeature.State(),
                reducer: { MyFeature() }
            )
        )
    } destination: { store in
        switch store.case {
            
        default:
            EmptyView()
        }
    }
  
}
