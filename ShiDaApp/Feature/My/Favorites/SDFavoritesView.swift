//
//  SDFavoritesView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/20.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDFavoritesView: View {
    @Perception.Bindable var store: StoreOf<SDFavoritesFeature>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                SDColor.background
                    .ignoresSafeArea()
                if store.bookList?.isEmpty == false {
                    contentView
                        .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索")
                } else if store.hasError {
                    // 显示错误视图
                    SDErrorView(config: .networkError())

                } else if store.bookList?.isEmpty == true {
                    // 显示空收藏视图
                    SDErrorView(config: .emptyData())
                }
            }
            .task {
                store.send(.onAppear)
            }
            .navigationTitle("我的收藏")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .toolbarBackground(SDColor.background, for: .navigationBar)
            //.sdLoadingToast(isPresented: $store.isLoading)
            
        }
    }
    
    // 内容视图
    var contentView: some View {
        WithPerceptionTracking {
            if !store.searchText.isEmpty && store.searchResults.isEmpty && !store.isSearching {
               
                SDErrorView(config: .emptyData())

            } else {
                ScrollView {
//                    RefreshHeader(refreshing: $store.isLoading) {
//                        store.send(.performSearch)
//                    } label: { _ in
//                        Text("加载中")
//                    }
                    LazyVStack(spacing: 16) {
                        
                        
                        

                        if !store.searchText.isEmpty {
                            ForEach(store.searchResults) { book in
                                WithPerceptionTracking {
                                    bookItemView(book: book)
                                }
                            }
                            
                        } else if let books = store.bookList {
                            // 显示所有图书
                            ForEach(books) { book in
                                WithPerceptionTracking {
                                    bookItemView(book: book)
                                }
                            }
                        }
                        
//                        RefreshFooter(refreshing: $store.isLoading) {
//                            
//                        } label: {
//                            YXFooterView(noMore: false, showNomore: false)
//                        }
//                        .noMore(true)
                        Text("Load More")
                            .onAppear {
                                print("=====Load More")
                            }
                        
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    
                    
                }// 显示搜索结果
                //.enableRefresh()
                        .refreshable {
                            await store.send(.performSearch).finish()
                        }
            }
        }
        
    }
    
    // 图书项视图
    private func bookItemView(book: SDResponseBookInfo) -> some View {
        NavigationLink(state: MyFeature.Path.State.bookDetail(SDBookDetailReducer.State(id: book.id))) {
            WithPerceptionTracking {
                SDBookItemView(book: book)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SDFavoritesView(
            store: Store(
                initialState: SDFavoritesFeature.State(),
                reducer: {
                    SDFavoritesFeature()
                        ._printChanges()
                }
            )
        )
    }
}
