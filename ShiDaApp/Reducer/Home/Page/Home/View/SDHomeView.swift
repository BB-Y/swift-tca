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
    let books = [
        "书籍1", "书籍2", "书籍3", "书籍4", "书籍5", "书籍6",
        "书籍7", "书籍8", "书籍9", "书籍10", "书籍11", "书籍12"
    ]
    @State var searchText = ""

    @State var show = false
    var body: some View {
        

        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
//                    .background {
//                        SDColor.background
//                            .ignoresSafeArea(.all)
//                    }
                ScrollView {
                    content
                        .padding(.horizontal, 16)
                }
                
                
                
                
            }
            .background(SDColor.background)
            .overlay {
                Button("TestView") {
                    store.send(.pushToTestView)
                }
                .buttonStyle(SDButtonStyleConfirm())
            }
            .overlay(alignment: .bottom) {
                if store.token.isEmpty {
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
                                .padding(.vertical, 8)
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
            
            .onAppear {
                store.send(.onAppear)
            }
            
            .fullScreenCover(item: $store.scope(state: \.login, action: \.login), content: { item in
                SDLoginHomeView(store: item)
            })
           
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
        
            Image("banner")
                .resizable()
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                .background(Color.yellow)
                .clipped()
                .onTapGesture {
                    store.send(.pushToTestView)
                }
                
            VStack {
                TitleView("十四五规划精品教材", "本教材紧扣国家“十四五”规划发展脉络，精心打造而成。内容全面涵盖了“十四五”期...")

                
                
                    
                
                HStack {
                    BookItemView()
                    Spacer()
                    BookItemView()
                    Spacer()
                    BookItemView()
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(8)
            
            VStack {
                TitleView("推荐位B型")

                ScrollView(.horizontal) {
                    HStack(spacing: 24) {
                        ForEach(0..<10) { index in
                            BookItemView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
            
            VStack {
                TitleView("推荐位C型","本教材紧扣国家“十四五”规划发展脉络，精心打造而成。内容全面涵盖了“十四五”期...")
                LazyV()
                
                

                
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(8)
        
    }
}

#Preview {
    SDHomeView(
        store: Store(
            initialState: SDHomeFeature.State(),
            reducer: { SDHomeFeature() }
        )
    )
    
}
    
