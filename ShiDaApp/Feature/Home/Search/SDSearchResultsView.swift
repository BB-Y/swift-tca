//
//  SDSearchResultsView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI
import ScalingHeaderScrollView

struct SDSearchResultsView: View {
    @Perception.Bindable var store: StoreOf<SDSearchResultsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                // 搜索结果内容
                if store.isSearchLoading {
                    EmptyView()
                } else if let results = store.searchResults, let books = results.rows, !books.isEmpty {
                    searchResultsContentView(books: books)
                } else if store.searchResults != nil {
                    // 只有在执行过搜索但没有结果时才显示空结果视图
                    searchEmptyResultView
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

  

    // 搜索结果为空视图
    var searchEmptyResultView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("没有找到匹配的图书")
                .font(.sdBody1)
                .foregroundColor(SDColor.text2)
            
            Text("请尝试其他关键词")
                .font(.sdBody2)
                .foregroundColor(SDColor.text3)
            Spacer()

        }
        .frame(maxWidth: .infinity)
        
    }

    // 搜索结果内容视图
    func searchResultsContentView(books: [SDResponseBookInfo]) -> some View {
        ScalingHeaderScrollView {
            Color.clear
                .frame(height: 0)
        } content: {
            LazyVStack(spacing: 16) {
                ForEach(books) { book in
                    bookItemView(book: book)
                        .onTapGesture {
                            store.send(.delegate(.bookSelected(book)))
                        }
                }
                Text("加载更多")
                
            }
            .padding(.vertical, 16)

        }
        .height(min: 0, max: 0)
        //.setHeaderSnapMode(.disabled)
        .pullToLoadMore(isLoading: $store.isLoadingMore, contentOffset: 10, perform: {
            store.send(.loadMoreSearch)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)


        

        
        
    }

    // 图书项视图
    func bookItemView(book: SDResponseBookInfo) -> some View {
        HStack(spacing: 16) {
            // 图书封面
            WebImage(url: book.cover?.url)
                .resizable()
                .scaledToFill()
                .frame(width: 88, height: 130)
                .clipped()
                .border(SDColor.divider)
            
            // 图书信息
            VStack(alignment: .leading, spacing: 8) {
                Text(book.name ?? "未知书名")
                    .font(.sdTitle1)
                    .foregroundStyle(SDColor.text1)
                    .lineLimit(2)
                
                if let authors = book.authorList, !authors.isEmpty {
                    Text(book.formattedAuthors)
                        .font(.sdBody2)
                        .foregroundStyle(SDColor.text2)
                        .lineLimit(1)
                    Spacer()
                }
                
                if let isbn = book.isbn {
                    Text("ISBN：\(isbn)")
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text3)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 箭头
            Image("arrow_right")
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    SDSearchResultsView(
        store: Store(
            initialState: SDSearchResultsFeature.State(),
            reducer: {
                SDSearchResultsFeature()
                    .dependency(\.searchClient, .liveValue)
            }
        )
    )
}


