//
//  SDStudyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import UIKit

struct StudyFeature: Reducer {
    struct State: Equatable {
        // 学习页面的状态
    }
    
    enum Action: Equatable {
        // 学习页面的动作
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 处理页面出现时的逻辑
                return .none
            }
        }
    }
}

struct StudyView: View {
    let store: StoreOf<StudyFeature>
    
    @State var tab = 0
    @Namespace var scrollview1
    @Namespace var scrollview2

    @State var offset: CGFloat = 0
    
    @State var offset1: CGFloat = 0
    @State var offset2: CGFloat = 0

    static let iconHeight: CGFloat = 150
    static let tabHeight: CGFloat = 44

    var headerFullHeight: CGFloat {
        StudyView.iconHeight + StudyView.tabHeight

    }
    @State var headerHeight: CGFloat? = nil
    @State var headerSwitchBeginHeight: CGFloat = iconHeight + tabHeight

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 1) {
                    top
                    tabbar
                }
                .frame(height: headerHeight, alignment: .bottom)
                .background(SDColor.background)

                TabView(selection: Binding(get: {
                    tab
                }, set: { value in
                    tab = value
                    resetHeaderHeight()
                    
                })) {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(0..<50) {
                                NavigationLink("页面1\($0)") {
                                    Text("子页面")
                                        
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .padding(.horizontal, 16)
                                
                            }
                        }
                        .overlay(alignment: .top) {
                            GeometryReader { proxy in
                                Color.blue
                                    .frame(height: 0)
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named(scrollview1)).minY)
                                    
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(SDColor.background)
                    .tag(0)
                    .coordinateSpace(name: scrollview1)
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        //print("====\(offset)")
//                        if self.offset = 0 {
//                            self.offset = offset
//
//                        }
                        offset1 = offset

                        if offset < 0 {
                            withAnimation {
                                headerHeight = 0

                            }
                        } else if offset >= 0{
                            withAnimation {
                                headerHeight = nil

                            }
                        }
                        
                        //headerHeight = headerSwitchBeginHeight + min(offset, 0)

                    }
                    ScrollView {
                        
                        LazyVStack {
                            
                            ForEach(0..<50) {
                                NavigationLink("页面2\($0)") {
                                    Text("子页面")
                                        
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .padding(.horizontal, 16)
                                
                            }
                        }
                        .overlay(alignment: .top) {
                            GeometryReader { proxy in
                                Color.blue
                                    .frame(height: 0)
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named(scrollview2)).minY)
                                    
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(SDColor.background)
                    .tag(1)
                    .coordinateSpace(name: scrollview2)
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        //print("====\(offset)")
                        offset2 = offset
                        if offset < 0 {
                            withAnimation {
                                headerHeight = 0

                            }
                        } else if offset >= 0{
                            withAnimation {
                                headerHeight = nil

                            }
                        }
                        //headerHeight = headerSwitchBeginHeight + min(offset, 0)

                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity)
                
            }
            .toolbarRole(.navigationStack)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(SDColor.background, for: .navigationBar)

            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    ZStack(alignment: .leading) {
                        
                        Text("教学")
                            .font(.sdLargeTitle1)
                            .opacity(headerHeight == nil ? 1 : 0)
                            
                        tabbar
                            //.frame(width: headerHeight > 0 ? 0 : nil)
                            
                            .opacity(headerHeight == nil ? 0: 1)
//                        Text("教学")
//                            .font(.sdTitle)
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .opacity((headerHeight > 0 && headerHeight < headerFullHeight) ? 1 : 0)

                        
                    }
                    .padding(.leading, 16)
                    .frame(width: UIScreen.main.bounds.width - 6, alignment: .trailing)
                    .animation(.linear)
                    .transition(.move(edge: .bottom))
                    
                    .overlay(alignment: .trailing) {
                        Text("+")
                            .frame(width: 44, height: 44, alignment: .center)
                        
                    }

                }
                
                
//                if headerHeight <= 0 {
//                    ToolbarItem(placement: .topBarLeading) {
//                        tabbar
//
//                    }
//
//                    
//                } else if headerHeight > 0, headerHeight < iconHeight + tabHeight {
//                    ToolbarItem(placement: .principal) {
//                        Text("教学")
//                    }
//
//                } else {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Text("教学")
//                    }
//
//                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            
//            .onChange(of: $tab) { oldValue, newValue in
//                print(oldValue)
//                print(newValue)
//
//                if newValue == 0 {
//                    if offset1 < 0 {
//                        headerHeight = 0
//                    }
//                } else if newValue == 1 {
//                    if offset2 < 0 {
//                        headerHeight = 0
//                    }
//                }
//            }
            
        }
    }
    private func resetHeaderHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            withAnimation {
                if tab == 0 {
                    if offset1 < 0 {
                        headerHeight = 0
                    }
                } else if tab == 1 {
                    if offset2 < 0 {
                        headerHeight = 0
                    }
                }
            }
        }
    }
    var top: some View {
        
        VStack {
            HStack {
                
                Color.red.frame(width: 50, height: 50)
                
                Color.blue.frame(width: 50, height: 50)
                Color.yellow.frame(width: 50, height: 50)
                
            }
            HStack {
                
                Color.red.frame(width: 50, height: 50)
                
                Color.blue.frame(width: 50, height: 50)
                Color.yellow.frame(width: 50, height: 50)
                
            }
        }
        //.frame(height: StudyView.iconHeight, alignment: .center)


    }
    @ViewBuilder var tabbar: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(0..<3, id: \.self) { index in
                Button {
                    tab =  index
                    resetHeaderHeight()
                    //headerSwitchBeginHeight = headerHeight
                     
                } label: {
                    VStack(spacing: 6) {
                        Text("标签\(index)")
                            .font(.sdBody2)
                            .foregroundColor(tab == index ? SDColor.primary : SDColor.text2)
                        
                        if tab == index {
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
        .frame(height: StudyView.tabHeight)
        //.background(Color.pink)
        
        
    }
}

#Preview {
    StudyView(
        store: Store(
            initialState: StudyFeature.State(),
            reducer: { StudyFeature() }
        )
    )
}
