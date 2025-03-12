//
//  SDBookListView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDBookListView: View {
    @Perception.Bindable var store: StoreOf<SDBookListFeature>
    // 移除本地的 searchText 状态
    // @State private var searchText: String = ""

    var body: some View {
        WithPerceptionTracking {
            
            VStack {
                if store.isLoading {
                    loadingView
                } else if store.hasError {
                    errorView
                } else {
                    contentView
                }
                
            }
            .navigationTitle(store.sectionTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                      ToolbarItem(placement: .navigationBarLeading) {
                          EmptyView()  // 这会清除返回按钮上的文字
                      }
                  }
            .toolbarRole(.editor)
            .background {
                SDColor.background
                    .ignoresSafeArea()
            }
            .task {
                store.send(.onAppear)
            }
            .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索")
          
        }
    }
    
    // 加载中视图
    var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<10, id: \.self) { _ in
                HStack {
                    Rectangle()
                        
                        
                        .frame(width: 80, height: 120)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            
                            
                            .frame(height: 20)
                        
                        Rectangle()
                            
                            .frame(height: 16)
                            .opacity(0.7)
                        
                        Rectangle()
                            
                            
                            .frame(height: 16)
                            .opacity(0.7)
                            .frame(width: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // 错误视图
    @ViewBuilder var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("加载失败，请重试")
                .font(.sdBody1)
                .foregroundColor(SDColor.text2)
            
            Button {
                store.send(.onAppear)
            } label: {
                Text("重新加载")
                    .padding(.horizontal, 32)
            }
            .buttonStyle(SDButtonStyleConfirm(isDisable: false))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // 内容视图
    var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                WithPerceptionTracking {
                    if !store.searchText.isEmpty && store.searchResults.isEmpty && !store.isSearching {
                        // 搜索无结果
                        VStack(spacing: 16) {
                            Text("没有找到匹配的图书")
                                .font(.sdBody1)
                                .foregroundColor(SDColor.text2)
                                .padding(.top, 40)
                        }
                    } else if !store.searchText.isEmpty {
                        // 显示搜索结果
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
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    // 图书项视图
    // 替换原有的 bookItemView 函数
    private func bookItemView(book: SDResponseHomeSectionBook) -> some View {
        
        NavigationLink(state: SDHomeFeature.Path.State.bookDetail(SDBookDetailReducer.State(id: book.id))) {
            WithPerceptionTracking {
                SDBookItemView(book: book)
            }
        }
        
    }
    
    
}

#Preview {
    NavigationStack {
        SDBookListView(
            store: Store(
                initialState: SDBookListFeature.State(
                    sectionId: 31,
                    sectionTitle: "十四五规划精品教材"
                ),
                reducer: {
                    SDBookListFeature()
                        ._printChanges()
                        .dependency(\.homeClient, .previewValue)
                }
            )
        )
    }
}
