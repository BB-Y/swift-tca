//
//  SDBookView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI
import UIKit
//Singleton Class View
class SingletonView: UIView {
    
    // Singleton instance
    static let shared : UIView = SingletonView.sharedInstance(size: CGSize(width: 20, height: 20))
    
    // You can modify argument list as per your need.
    class private func sharedInstance(size : CGSize)->UIView {
        //Putting the view in the middle, but the details falls on you.
        let view = UIView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - size.width/2, y: 0, width: size.width, height: size.height))
        //just so you can see something
        view.layer.backgroundColor = UIColor.red.cgColor
        let label = UILabel()
        label.text = "123"
        view.addSubview(label)
        return view
    }
    
}
struct SDBookHomeView: View {
    @Perception.Bindable var store: StoreOf<SDBookFeature>
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            WithPerceptionTracking {
                VStack(spacing: 0) {
                    // 自定义导航栏
                    header
                    
                    
                    // 分类标签栏
                    categoryTabBar
                    
                    
                    // 排序选项
                    sortOptionsBar
                    
                    Color.clear.overlay {
                        searchResultsContainer
                    }
                    
                    
                        
                    // 内容区域
                    
                    
                    
                }
                .background(Color.white.ignoresSafeArea())
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.navigationStack)
            .toolbar(.hidden, for: .navigationBar)
            .task {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .bookDetail(let store):
                SDBookDetailView(store: store)
                    .hideToolBar()
            }
        }
    }
    
    // 顶部搜索栏
    @ViewBuilder var header: some View {
        HStack(spacing: 2) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(width: 16, height: 16)
            
            
            TextField("请输入书名/ISBN/作者", text: $store.searchText)
                .onSubmit {
                    store.send(.submitSearch)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(SDColor.text1)
                .modifier(SDTextFieldWithClearButtonModefier(text: $store.searchText))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.sdBody3)
        .padding(.horizontal, 10)
        .frame(height: 36)
        .background { SDColor.buttonBackGray }
        .clipShape(Capsule())
        
        .padding(.horizontal, 16)
        
        .frame(height: 44)
        
        .background { Color.white.ignoresSafeArea() }
        
        
    }
    
    // 分类标签栏
    @ViewBuilder var categoryTabBar: some View {
        
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // 全部分类选项
                    categoryButton(id: nil, name: "全部")
                    
                    // 动态分类选项
                    ForEach(store.categories) { category in
                        categoryButton(id: category.id, name: category.name ?? "")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
            }
            
            // 二级分类（如果有）
            if !store.subCategories.isEmpty {
                SDWrappingHStack( store.subCategories) { category in
                    
                    categoryButton(id: category.id, name: category.name ?? "", isSub: true)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                .background(SDColor.background)
                
                
            }
        }
        
        
        .background(Color.white)
        
        
    }
    
    // 分类按钮
    func categoryButton(id: Int?, name: String, isSub: Bool = false) -> some View {
        Button {
            if isSub{
                store.send(.selectSubCategory(id))
            } else {
                store.send(.selectCategory(id))
                
            }
        } label: {
            let currentid = isSub ? store.selectedSubCategoryId : store.selectedCategoryId
            Text(name)
                .font(.sdBody2)
                .foregroundColor(currentid == id ? SDColor.primary : SDColor.text2)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(currentid == id ? SDColor.primary.opacity(0.1) : SDColor.buttonBackGray)
                )
        }
        
    }
    
    // 排序选项栏
    @ViewBuilder var sortOptionsBar: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(SDSearchSortType.allCases, id: \.self) { sortType in
                Button {
                    store.send(.changeSortType(sortType))
                } label: {
                    VStack(spacing: 6) {
                        Text(sortType.title)
                            .font(.sdBody2)
                            .foregroundColor(store.currentSortType == sortType ? SDColor.primary : SDColor.text2)
                        
                        if store.currentSortType == sortType {
                            Capsule()
                                .fill(SDColor.primary)
                                .frame(width: 32, height: 3)
                        }
                    }
                }
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .background(Color.white)
        
        
    }
    
    // 书籍列表内容
    @ViewBuilder var bookListContent: some View {
        if let searchResults = store.searchResultsFeature.searchResults, let books = searchResults.rows, !books.isEmpty {
            VStack(spacing: 12) {
                ForEach(books) { book in
                    bookItemView(book: book)
                        .onTapGesture {
                            store.send(.searchResultsFeature(.delegate(.bookSelected(book))))
                        }
                }
                
                if store.searchResultsFeature.canLoadMore {
                    Button {
                        store.send(.searchResultsFeature(.loadMoreSearch))
                    } label: {
                        HStack {
                            if store.searchResultsFeature.isLoadingMore {
                                ProgressView()
                                    .frame(width: 20, height: 20)
                            }
                            Text(store.searchResultsFeature.isLoadingMore ? "加载中..." : "加载更多")
                                .font(.sdBody2)
                                .foregroundColor(SDColor.text2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .disabled(store.searchResultsFeature.isLoadingMore)
                }
            }
            .padding(.vertical, 12)
        } else {
            emptyContentView
        }
    }
    
    // 图书项视图
    func bookItemView(book: SDResponseHomeSectionBook) -> some View {
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
    
    // 空内容视图
    var emptyContentView: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("暂无图书")
                .font(.sdBody1)
                .foregroundColor(SDColor.text2)
            
            Text("请尝试其他分类或搜索关键词")
                .font(.sdBody2)
                .foregroundColor(SDColor.text3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
    }
    
    
    
    // 搜索结果容器视图
    var searchResultsContainer: some View {
        // 搜索结果视图
        SDSearchResultsView(
            store: store.scope(
                state: \.searchResultsFeature,
                action: \.searchResultsFeature
            )
        )
        .scrollIndicators(.hidden)
        
        .onAppear{
            
            //Hide the default refresh controller, attach our uiView
            //Because is a singleton it wont be added several times
            //You can always expand your singleton to be hidden, animated, removed, etc.
            UIRefreshControl.appearance().tintColor = .systemRed
            UIRefreshControl.appearance().addSubview(SingletonView.shared)
            
        }
        
//        .refreshable {
//            await store.send(.searchResultsFeature(.submitSearch(.keyword(store.searchText)))).finish()
//        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
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
    SDBookHomeView(
        store: Store(
            initialState: SDBookFeature.State(),
            reducer: {
                SDBookFeature()
                    .dependency(\.bookClient, .liveValue)
                    .dependency(\.searchClient, .liveValue)
                    ._printChanges()
            }
        )
    )
}
