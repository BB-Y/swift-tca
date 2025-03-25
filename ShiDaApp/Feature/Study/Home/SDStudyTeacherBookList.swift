//
//  SDStudyTeacherBookList.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/24.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI
import ScalingHeaderScrollView

struct SDStudyTeacherBookList: View {
    @Perception.Bindable var store: StoreOf<SDStudyTeacherBookListFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                if let results = store.bookResults, let books = results.rows, !books.isEmpty {
                    SDStudyHomeScrollView(isTop: $store.isTop) {
                        Button {
                            store.send(.view(.addTeacherBook))
                        } label: {
                            Image(systemName: "plus")
                            Text("添加教师用书")
                        }
                        .tint(SDColor.text2)
                        .font(.sdBody2)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(SDColor.buttonBackGray)
                        }
                        .padding(.horizontal, 16)

                        ForEach(books, id: \.id) { book in
                            bookItemView(book: book)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    store.send(.delegate(.bookSelected(book)))
                                }
                        }
                        if store.canLoadMore {
                            Text("加载更多")
                                .font(.sdBody2)
                                .foregroundColor(SDColor.text3)
                            .padding(.vertical, 10)
                            .onAppear {
                                if !store.isLoadingMore {
                                    store.send(.loadMoreBooks)
                                }
                            }
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            //.sdErrorOverlay(isPresented: <#T##Binding<Bool>#>, config: <#T##SDErrorConfig#>, content: <#T##() -> View#>)
            .onAppear {
                store.send(.view(.onAppear))
            }
        }
    }
    
   
    
    
    
   
    
    // 图书项视图
    func bookItemView(book: SDStudyMyDbookDto) -> some View {
        HStack(spacing: 16) {
            // 图书封面
            WebImage(url: book.dbookCover?.url)
                .resizable()
                .scaledToFill()
                .frame(width: 73, height: 108)
                .clipped()
                .border(SDColor.divider)
            
            // 图书信息
            VStack(alignment: .leading, spacing: 8) {
                Text(book.dbookName ?? "未知书名")
                    .font(.sdBody2)
                    .foregroundStyle(SDColor.text1)
                    .lineLimit(2)
                
                if let authors = book.authors {
                    Text("\(authors) 著")
                        .font(.sdBody2)
                        .foregroundStyle(SDColor.text2)
                        .lineLimit(1)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button("上课") {
                        store.send(.view(.toLesson))
                    }
                    .buttonStyle(.sdSmall1())
                    .frame(width: 76, height: 26)
                }
                
                
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            
           
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    NavigationView {
        SDStudyTeacherBookList(
            store: Store(
                initialState: SDStudyTeacherBookListFeature.State(isTop: Shared(value: true)),
                reducer: {
                    SDStudyTeacherBookListFeature()
                        .dependency(\.studyClient, .previewValue)
                }
            )
        )
    }
}
