//
//  SDStudyView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import UIKit

@Reducer
struct StudyFeature {
    @ObservableState
    struct State: Equatable {
        
        @Shared var isTop: Bool
        
        var teacherBooks = Array(0..<50)
        var myBooks = Array(0..<5)
        var lives = Array(0..<10)

        // 学习页面的状态
        @Shared(.shareUserInfo) var userInfoData = SDResponseLogin.jsonModel.data(using: .utf8)
        var teacherBookState: SDStudyTeacherBookListFeature.State = .init(isTop: Shared(value: false))

        
        var userInfo: SDResponseLogin? {
            guard let data = userInfoData else { return nil }
            return try? JSONDecoder().decode(SDResponseLogin.self, from: data)
        }
        var isStudent : Bool {
            userInfo?.userType == .student
        }
        
        var currentTab: TabItem = .book
        var tabs: [TabItem] {
            isStudent ? [.book, .live] : [.teacher, .book, .live]
        }
        enum TabItem : Equatable{
            case book
            case live
            case teacher
            
            var title: String {
                switch self {
                case .book:
                    return "我的教材"
                case .live:
                    return "直播课程"
                case .teacher:
                    return "教师用书"
                }
            }
        }
        var topItems: [SDStudyType] {
            
            var items:[SDStudyType]
            if isStudent {
                items = [.notes, .documents, .exam, .statistics, .classDiscussion, .taskManagement]
               
            } else {
                items = [.notes, .documents, .exam, .statistics, .classManagement,.classDiscussion, .taskManagement, .liveTeaching]
               
            }
            return items
        }
        init() {
            _isTop = Shared(value: false)
            _teacherBookState = .init(isTop: $isTop)
                        

           // _userInfoData = Shared(value: SDResponseLogin.jsonModel.data(using: .utf8)!)
            if isStudent {
                currentTab = .book
            } else {
                currentTab = .teacher
            }
        }
    }
    
    enum Action: ViewAction, BindableAction {
        // 学习页面的动作
        case view(View)
        case binding(BindingAction<State>)
        case teacherBookAction(SDStudyTeacherBookListFeature.Action)
        enum View {
            case onAppear
            case onTabItemTapped(State.TabItem)

        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
//            .onChange(of: \.isTop) { oldValue, newValue in
//                Reduce { state, action in
//                         .run { send in
//                           // Persist new value...
//                         }
//                       }
//            }
        Scope(state: \.teacherBookState, action: \.teacherBookAction) {
            SDStudyTeacherBookListFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .onAppear:
                    // 处理页面出现时的逻辑
                    return .none
                case .onTabItemTapped(let tab):
                    state.currentTab = tab
                    return .none
                }
            case .binding:
                return .none
           
            case .teacherBookAction(_):
                return .none
            }
        }
    }
}

@ViewAction(for: StudyFeature.self)
struct StudyView: View {
    @Perception.Bindable var store: StoreOf<StudyFeature>
    
    
    @Namespace var scrollview1
    
    @State var id1 = 1000
    @State var id2 = 2000
    @State var id3 = 3000

    
    
    
    
    
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                VStack(spacing: 0) {
                    if !store.isTop {
                        topView
                    }
                    
                    
                    
                    tabView
                    
                    
                }
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        bar
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("+")
                            .font(.sdLargeTitle1)
                            .foregroundStyle(SDColor.text1)
                            .frame(width: 44, height: 44, alignment: .center)
                    }

                })
                .navigationBarTitleDisplayMode(.inline)
                .background(SDColor.background.ignoresSafeArea())
                .toolbarRole(.navigationStack)
                .toolbarBackground(.automatic, for: .navigationBar)
                .toolbarBackground(store.isTop ? SDColor.warning : Color.clear, for: .navigationBar)
                
                
            }
            
            
            
        }
    }
    var bar: some View {
        ZStack(alignment: .leading) {

            Text("教学")
                .font(.sdLargeTitle1)
                .opacity(store.isTop ? 0 : 1)

            tabbar
                .opacity(store.isTop ? 1: 0)



        }
        //.padding(.leading, 16)
//        .frame(width: UIScreen.main.bounds.width - 6, alignment: .trailing)
//        .animation(.easeInOut, value: isTop)
//        .overlay(alignment: .trailing) {
//            Text("+")
//                .frame(width: 44, height: 44, alignment: .center)
//        }
    }
    var topView: some View {
        
        VStack(spacing: 0) {
            iconView
            tabbar
        }
        .background {
            LinearGradient(
                colors: [
                    Color.white,
                    SDColor.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    var iconView: some View {
        
        VStack {
            SDLazyVGrid(data: store.topItems, columns: 4, width: 52, vSpacing: 12) { item in
                VStack(spacing: 8) {
                    Image(item.icon)
                    Text(item.title(.student))
                        .font(.sdSmall1)
                        .foregroundStyle(SDColor.text1)
                        .lineLimit(1)
                        .fixedSize()
                }
            }
            
        }
        .padding(.horizontal, 28)
        .padding(.top, 16)
        .padding(.bottom, 24)
        //.frame(height: StudyView.iconHeight, alignment: .center)
    }
    var tabbar: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(store.tabs, id: \.self) { tab in
                Button {
                    send(.onTabItemTapped(tab))
                    //tab =  index
                } label: {
                    VStack(spacing: 6) {
                        Text(tab.title)
                            .font(.sdBody2)
                            .foregroundColor(tab == store.currentTab ? SDColor.primary : SDColor.text2)
                        
                        Capsule()
                            .fill(SDColor.primary)
                            .frame(width: 32, height: 3)
                            .opacity(tab == store.currentTab ? 1 : 0)
                    }
                    

                }
                .frame(height: 32, alignment: .top)
                
                
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        

        
        
        
    }
    
    var tabView: some View {
        TabView(selection: $store.currentTab) {
            
            SDStudyTeacherBookList(store: store.scope(state: \.teacherBookState, action: \.teacherBookAction))
           
            .tag(StudyFeature.State.TabItem.teacher)
            .id(id1)
            list {
                ForEach(store.myBooks) {
                    NavigationLink("页面2\($0)") {
                        Text("子页面")
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .padding(.horizontal, 16)
                    
                }
            }
            .tag(StudyFeature.State.TabItem.book)
            .id(id2)
            list {
                ForEach(store.lives) {
                    NavigationLink("页面3\($0)") {
                        Text("子页面")
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .padding(.horizontal, 16)
                    
                }
            }
            .tag(StudyFeature.State.TabItem.live)
            .id(id3)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
        .animation(.easeInOut, value: store.isTop)
        .transition(.move(edge: .top))
    }
    
    func list<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            
            LazyVStack {
                
                content()
            }
            .padding(.vertical, 16)
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
        .coordinateSpace(name: scrollview1)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            
            if store.isTop {
                if offset > 0 {
                    withAnimation {
                        store.isTop = false
                        
                    }
                    id2 += 1
                }
            } else {
                if offset < 0 {
                    withAnimation {
                        store.isTop = true
                        
                    }
                }
            }
            
        }
    }

}

#Preview {
    StudyView(
        store: Store(
            initialState: StudyFeature.State(),
            reducer: { StudyFeature()._printChanges() }
        )
    )
}
