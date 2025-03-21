//
//  SDHomeView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDHomeView: View {
    @Perception.Bindable var store: StoreOf<SDHomeFeature>
    
    var listData: [SDResponseHomeSection] {
        store.homeData ?? []
    }
    @FocusState var focusState
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            WithPerceptionTracking {
                VStack(spacing: 0) {
                    // 自定义导航栏
                    header
                        
                    
                    ZStack {
                        ScrollView {
                            content
                                .padding(.top, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        .scrollIndicators(.hidden)
                        if store.loginStatus != .login {
                            VStack {
                                Spacer()
                                login
                            }
                            .frame(maxWidth: .infinity)
                        }
                        if store.isSearchActive {
                            SDSearchOverlay(store: store.scope(state: \.searchOverlay, action: \.searchOverlay))
                                .ignoresSafeArea(edges: .bottom)
                                .transition(.opacity)
                                .hideKeyboardWhenTap()

                        }
                        if store.isShowingSearchResults {
                            searchResultsContainer
                                .ignoresSafeArea(edges: .bottom)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .hideKeyboardWhenTap()

                        }
                    }
                    
                }
                .sdLoadingToast(isPresented: $store.isLoading)

                
                .frame(maxWidth: .infinity)
                .background(SDColor.background)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea(.keyboard, edges:  .bottom)

                .task {
                    store.send(.onAppear)
                }
            }
            
            
        } destination: { store in
            switch store.case {
            case .test(let store):
                SDHomeTestView(store: store)
            case .bookList(let store):
                SDBookListView(store: store)
                    .toolbar(.hidden, for: .tabBar)
            case .schoolList(let store):
                SDSchoolListView(store: store)
                    .toolbar(.hidden, for: .tabBar)
                
            case .bookDetail(let store):
                SDBookDetailView(store: store)
                    .toolbar(.hidden, for: .tabBar)
                
            }
        }
    }
    
    var login: some View {
        SDLoginNoticeView {
            store.send(.onLoginTapped)
        }
    }
    
    @ViewBuilder var header: some View {
        HStack {
            if !store.isSearchActive {
                Image("logo")
            }
            
            HStack(spacing: 2) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)
                
                if store.isSearchActive {
                    HStack(spacing: 12) {
                        TextField("请输入书名/ISBN/作者", text: $store.searchText)
                        
                            .onSubmit {
                                store.send(.submitSearch)
                            }
                            .focused($focusState)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(SDColor.text1)
                        
                            .modifier(SDTextFieldWithClearButtonModefier(text: $store.searchText))
                        
                        SDLine(SDColor.text3, axial: .vertical)
                            .frame(height: 14)
                        Button("取消") {
                            store.send(.toggleSearch)
                        }
                        .foregroundStyle(SDColor.text1)
                        
                    }
                } else {
                    Text("请输入书名/ISBN/作者")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(SDColor.text3)
                    
                        .onTapGesture {
                            store.send(.toggleSearch)
                            focusState.toggle()
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.sdBody3)
            .padding(.horizontal, 10)
            .frame(height: 32)
            .background { SDColor.buttonBackGray }
            .clipShape(Capsule())
            
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        
        .background {
            if store.isSearchActive {
                Color.white.ignoresSafeArea()
            }
        }
        
    }
    
    @ViewBuilder var content: some View {
        VStack(spacing: 20) {
            ForEach(listData) { sectionData in
                SDHomeSectionView(
                    item: sectionData,
                    onItemTap: { item in
                        store.send(.onSectionItemTapped(item))
                    },
                    onTitleTap: { section in
                        store.send(.onSectionTitleTapped(section))
                    }
                )
            }
        }
    }
    // 搜索结果容器视图
    var searchResultsContainer: some View {
        VStack(spacing: 0) {
            // 搜索加载中视图
//            if store.searchResultsFeature.isSearchLoading {
//                searchLoadingView
//            }
            
            // 搜索结果视图
            SDSearchResultsView(
                store: store.scope(
                    state: \.searchResultsFeature,
                    action: \.searchResultsFeature
                )
            )
            //        .refreshable {
            //            await store.send(.searchResultsFeature(.submitSearch(.keyword(store.searchText)))).finish()
            //        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.white.ignoresSafeArea()
        }
    }
    
    // 搜索加载中视图
    var searchLoadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { _ in
                HStack {
                    Rectangle()
                        .skeleton(with: true)
                        .frame(width: 80, height: 120)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .skeleton(with: true)
                            .frame(height: 20)
                        
                        Rectangle()
                            .skeleton(with: true)
                            .frame(height: 16)
                            .opacity(0.7)
                        
                        Rectangle()
                            .skeleton(with: true)
                            .opacity(0.7)
                            .frame(width: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
    }
    
    
    
}

#Preview {
    SDHomeView(
        store: Store(
            initialState: SDHomeFeature.State(),
            reducer: {
                SDHomeFeature()
                    .dependency(\.homeClient, .previewValue)
                    ._printChanges()
                    .dependency(\.searchClient, .liveValue)
            }
        )
    )
}





