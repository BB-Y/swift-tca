//
//  SDSchoolListView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/15.
//

import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDSchoolListView: View {
    @Perception.Bindable var store: StoreOf<SDSchoolListFeature>
    
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
                        .frame(width: 60, height: 60)
                        .skeleton(with: true)
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .frame(height: 20)
                            .skeleton(with: true)


                        Rectangle()
                            .frame(height: 16)
                            .opacity(0.7)
                            .frame(width: 100)
                            .skeleton(with: true)

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
                    .padding(.vertical, 6)

                    .padding(.horizontal, 32)
            }
            .buttonStyle(.sdConfirm(isDisable: false))
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
                            Text("没有找到匹配的院校")
                                .font(.sdBody1)
                                .foregroundColor(SDColor.text2)
                                .padding(.top, 40)
                        }
                    } else if !store.searchText.isEmpty {
                        // 显示搜索结果
                        ForEach(store.searchResults) { school in
                            WithPerceptionTracking {
                                schoolItemView(school: school)
                                    .onTapGesture {
                                        store.send(.onSchoolTapped(school))
                                    }
                            }
                        }
                    } else if let schools = store.schoolList {
                        // 显示所有院校
                        ForEach(schools) { school in
                            NavigationLink(state: SDHomeFeature.Path.State.bookList(SDBookListFeature.State(
                                sourceType: .school(school.id),
                                sectionTitle: school.name ?? "学校图书"
                            ))) {
                                WithPerceptionTracking {
                                    schoolItemView(school: school)
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    // 院校项视图
    func schoolItemView(school: SDResponseHomeSectionSchool) -> some View {
        HStack(spacing: 16) {
            // 院校图标
            WebImage(url: school.iconUrl?.url)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
                .overlay(
                    Circle()
                        .stroke(SDColor.divider, lineWidth: 1)
                )
            
            // 院校信息
            VStack(alignment: .leading, spacing: 8) {
                Text(school.name ?? "未知院校")
                    .font(.sdTitle1)
                    .foregroundStyle(SDColor.text1)
                    .lineLimit(1)
                
            
                
                if let count = school.dbookCount {
                    Text("图书数量：\(count)")
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text3)
                }
            }
            //.padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 箭头
            Image("arrow_right")
                
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        SDSchoolListView(
            store: Store(
                initialState: SDSchoolListFeature.State(
                    sectionId: 30,
                    sectionTitle: "合作院校"
                ),
                reducer: {
                    SDSchoolListFeature()
                        ._printChanges()
                        .dependency(\.homeClient, .previewValue)
                }
            )
        )
    }
}
