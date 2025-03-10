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
   
    @State var searchText = ""

    @State var show = false
    
    var listData: [SDResponseHomeSection] {
        store.homeData ?? []
    }
    var body: some View {
        

        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            WithPerceptionTracking {
                VStack(spacing: 20) {
                    header
                        .padding(.horizontal, 16)
    //                    .background {
    //                        SDColor.background
    //                            .ignoresSafeArea(.all)
    //                    }
                    ScrollView {
                        content
                            
                    }
                    .scrollIndicators(.hidden)
                    
                    
                    
                    
                }
            }
            
            .background(SDColor.background)

            .overlay(alignment: .bottom) {
                if store.loginStatus != .login {
                    HStack {
                        Text("登录体验更多精彩内容！")
                            .font(.sdBody2)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Button {
                            store.send(.onLoginTapped)

                        } label: {
                            Text("立即登录")
                                .padding(.horizontal, 32)
                        }
                        .buttonStyle(SDButtonStyleConfirm(isDisable: false))

                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .background {
                        SDColor.text1.opacity(0.8)
                    }
                }
                
            }
            //.hideToolBar()
            .navigationTitle("")
            .task{
                store.send(.onAppear)

            }
           
           
           
        } destination: { store in
            switch store.case {
            case .test(let store):
                SDHomeTestView(store: store)
            }
        }
        
    }
    
    @ViewBuilder var header: some View {
        HStack {
            Image("logo")
                .imageScale(.large)
                .foregroundColor(Color.red)
            Spacer()
            HStack(spacing: 2) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)
                    
                TextField("请输入书名/ISBN/作者", text: $searchText)
                
                    .keyboardType(.numberPad)
                    .accentColor(.red)
                    
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 4)
                    .padding(.leading, 2)
                    .frame(maxWidth: .infinity)
                
                    
            }
            .padding(.horizontal,10)
            .padding(.vertical,8)
            .background(Color(.systemGray5))
            .clipShape(Capsule())
        }
        .frame(height: 44)
        
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
}

#Preview {
    SDHomeView(
        store: Store(
            initialState: SDHomeFeature.State(),
            reducer: { 
                SDHomeFeature()
                    .dependency(\.homeClient, .liveValue)

                    ._printChanges()
                
            }
        )
    )
    
    
}
    
