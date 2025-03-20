 //
//  SDBookDetailView.swift
//  ShiDaApp
//
//  Created by AI on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI
import ScalingHeaderScrollView
import ExyteGrid
import PopupView

@ViewAction(for: SDBookDetailReducer.self)
struct SDBookDetailView: View {
    @Perception.Bindable var store: StoreOf<SDBookDetailReducer>
    
    
    @State var progress: CGFloat = 0
    @State private var scrollToTop: Bool = false

    
    var safeAreaHeight: CGFloat {
        UIApplication.statusBarAndNavigationBarHeight
    }
    var tabbarHeight: CGFloat {
        40
    }
    var minHeight: CGFloat {
        UIApplication.statusBarAndNavigationBarHeight + tabbarHeight
    }
    var maxHeight: CGFloat{
        if store.userInfoModel?.userType == .teacher {
            return safeAreaHeight + tabbarHeight + topPadding + coverHeight + spacing * 2 + teacherButtonHeight

        }
        return safeAreaHeight + tabbarHeight + topPadding + coverHeight + spacing
    }
    var topPadding : CGFloat = 16
    var coverHeight: CGFloat = 150
    var spacing: CGFloat  = 20
    var teacherButtonHeight: CGFloat = 40
    
    var headerBookHeight: CGFloat {
        safeAreaHeight + topPadding + coverHeight
    }
   
    var body: some View {
        ZStack(alignment: .top) {
            SDColor.background.ignoresSafeArea()
            content
            bar
            
            if let errorMessage = store.errorMessage {
                SDErrorView(config: .networkError())
                
            }
            
            
        }

        .fullScreenCover(item: $store.scope(state: \.login, action: \.login), content: { item in
            WithPerceptionTracking {
                SDLoginHomeView(store: item)

            }
        })
        
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .sdAlert(isPresented: $store.showTeacherAlert,
                 title: "温馨提示",
                 message: "您还不是平台的认证教师，暂时无法使用该功能。成为认证教师后，将会开放更多功能",
                 buttons: [
                    .init(title: "取消", style: .cancel, action: {}),
                        .init(title: "前往认证", style: .default, action: {})
                 ])
        .task {
            send(.onAppear)
        }
        .sdLoadingToast(isPresented: $store.isLoading)
        
        
    }
    var bar: some View {
        HStack {
            Button {
                send(.onBackTapped)
            } label: {
                Image("back")
            }
            Spacer()
            if let bookDetail = store.bookDetail {
                Text(bookDetail.name)
                    .font(.sdTitle)
                    .foregroundStyle(SDColor.text1)
                    .opacity(progress)
            }
            
            Spacer()
            Button {
                send(.favoriteButtonTapped)
            } label: {
                Image(store.isFavorite ? "star_fill" : "star")
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(Color(hex: "#E7F1EE").opacity(progress))
    }
    @ViewBuilder var content: some View {
        if let bookDetail = store.bookDetail {
            ScalingHeaderScrollView {
                VStack(spacing: 20) {
                    bookHeaderSection(bookDetail: bookDetail)
                    
                    if store.userInfoModel?.userType == .teacher {
                        teacherApplyButton()
                    }
                    
                    
                    tab
                    
                    
                }
                .frame(height: maxHeight - tabbarHeight)
                .background(content: {
                    SDColor.background
                })
                .frame(width: UIScreen.main.bounds.width, height: maxHeight)
                
                
            } content: {
                tabViewContent(bookDetail: bookDetail)
            }
            .collapseProgress($progress)
            
            .scrollToTop(resetScroll: $scrollToTop)
            .height(min: minHeight, max: maxHeight)
            .background(SDColor.background)
            .ignoresSafeArea(edges: .top)
            //                .overlay(alignment: .bottom, content: {
            //                    bottomActionButtons()
            //                })
            .safeAreaInset(edge: .bottom) {
                bottomActionButtons()
            }
            .scrollIndicators(.hidden)
        }
    }
    var tab: some View {
        HStack(spacing: 24) {
            ForEach([SDBookDetailReducer.State.TabSelection.catalog,
                     .introduction,
                     .publishInfo], id: \.self) { tab in
                         Button {
                             scrollToTop = true
                             send(.tabSelected(tab))
                         } label: {
                             Text(tab.description)
                                 .font(.sdBody)
                                 .foregroundColor(store.selectedTab == tab ? .primary : .secondary)
                                 .fontWeight(store.selectedTab == tab ? .medium : .regular)
                                 .overlay(alignment: .bottom) {
                                     
                                     Capsule()
                                         .fill(store.selectedTab == tab ? SDColor.accent : Color.clear)
                                         .frame(height: 3)
                                         .offset(x: 0, y: 6)
                                 }
                                 .padding(.bottom, 8)
                         }
                     }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: tabbarHeight, alignment: .bottom)
        .background {
            if progress >= 0.98 {
                Color(hex: "#E7F1EE")
            } else {
                SDColor.background
            }
        }
    }
 
    @ViewBuilder
    private func bookDetailContent(bookDetail: SDBookDetailModel) -> some View {
        
        VStack(alignment: .leading, spacing: spacing) {
            // 顶部封面和基本信息
            bookHeaderSection(bookDetail: bookDetail)
            teacherApplyButton()
            // 标签页内容
            tabViewContent(bookDetail: bookDetail)
        }
        
        
        
    }
    
    // 顶部封面和基本信息
    @ViewBuilder
    private func bookHeaderSection(bookDetail: SDBookDetailModel) -> some View {
        HStack(alignment: .top, spacing: 16) {
    
            WebImage(url: URL(string: bookDetail.cover ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .frame(width: 104, height: coverHeight)
           
            // 书籍信息
            VStack(alignment: .leading, spacing: 10) {
                Text(bookDetail.name ?? "未知书名")
                    .font(.sdLargeTitle1.bold())
                    .lineLimit(3)
                    .lineSpacing(8)
                
                if let authors = bookDetail.authorList, !authors.isEmpty {
                    Text(authors.map { "作者：\($0.name ?? "")" }.joined(separator: " / "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        .padding(.horizontal, 16)
        .frame(height: headerBookHeight, alignment: .bottom)
        .background {
            LinearGradient(
                colors: [
                    SDColor.accent.opacity(0.2),
                    SDColor.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            //.padding(.top, -safeAreaInsets.top - 44)
        }
        

    }
    
    
    // 教师申请按钮
    @ViewBuilder
    private func teacherApplyButton() -> some View {
        HStack {
            Text("申请教师用书，开启更多教师功能")
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
        }
        .font(.sdBody3)
        .foregroundStyle(SDColor.blue)
        .padding(.horizontal,12)
        .frame(height: teacherButtonHeight)
        .background {SDColor.blueBack}
        .cornerRadius(8)
        .padding(.horizontal, 16)
        
        .onTapGesture {
            send(.applyForTeacherBook)
            
        }
    }
    
    // 标签页内容
    @ViewBuilder
    private func tabViewContent(bookDetail: SDBookDetailModel) -> some View {
        
        VStack {
            switch store.selectedTab {
            case .catalog:
                catalogContent(chapters: bookDetail.catalogList)
            case .introduction:
                introductionContent(bookDetail: bookDetail)
            case .publishInfo:
                publishInfoContent(bookDetail: bookDetail)
            }
        }
        .padding(.horizontal, 16)
        .background(SDColor.background)
        .padding(.top, 16)
        
    }
    
    // 目录内容
    @ViewBuilder
    private func catalogContent(chapters: [SDBookChapter]?) -> some View {
        if let chapters = chapters, !chapters.isEmpty {
            VStack(spacing: 0) {
                ForEach(chapters, id: \.id) { chapter in
                    ChapterRowView(
                        chapter: chapter,
                        isExpanded: store.expandedChapters.contains(chapter.id ?? 0),
                        onTap: { chapterId in
                            send(.chapterTapped(chapterId))
                        }
                    )
                }
            }
            
            .padding(16)
            .background {
                Color.white.cornerRadius(8)
            }
            
            

        } else {
            Text("暂无目录信息")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 300)
                .padding()
        }
    }
    
    // 图书简介内容
    @ViewBuilder
    private func introductionContent(bookDetail: SDBookDetailModel) -> some View {
        VStack(spacing: 12) {
            
            if let introduction = bookDetail.introduction {
                introductionContentItem(title: "图书简介", detail: introduction)
            }
            if let recommended = bookDetail.recommended, recommended.isEmpty == false {
                introductionContentItem(title: "编辑推荐", detail: recommended)
                
            }
            
            
        }
        
        
    }
    func introductionContentItem(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.sdBody1.weight(.medium))
                .foregroundStyle(SDColor.text1)
            Text(detail)
                .font(.sdBody2)
                .foregroundStyle(SDColor.text2)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            Color.white
        }
        .cornerRadius(8)
    }
    // 出版信息内容
    @ViewBuilder
    private func publishInfoContent(bookDetail: SDBookDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            infoRow(title: "作者", value: bookDetail.formattedAuthors)

            infoRow(title: "ISBN", value: bookDetail.isbn)

            infoRow(title: "出版社", value: bookDetail.publisher)
            if let status = bookDetail.publishStatus {
                infoRow(title: "出版状态", value: status.description)
            }
            infoRow(title: "出版日期", value: bookDetail.publishDatetime)
            if let cooperation = bookDetail.cooperation, !cooperation.isEmpty {
                infoRow(title: "合作单位", value: cooperation)
            }
            
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background {
            Color.white
        }
        .cornerRadius(8)
        

    }
    
    // 信息行
    @ViewBuilder
    private func infoRow(title: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            HStack(alignment: .top) {
                Text(title + "：")
                    .foregroundStyle(SDColor.text2)
                    .frame(width: 80, alignment: .leading)
                Text(value)
                    .foregroundStyle(SDColor.text1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.sdBody3)

            
        }
    }
    
    
    var confimButtonColor: Color {
        if store.loginStatus == .login {
            if store.bookDetail?.isActived == true {
                return SDColor.accent
            } else {
                return Color(hex: "#3897E0")
            }
        } else {
            return SDColor.accent
        }
    }
    var confimButtonTitle: String {
        if store.loginStatus == .login {
            if store.bookDetail?.isActived == true {
                return "开始阅读"
            } else {
                return "激活码激活图书"
            }
        } else {
            return "开始阅读"
        }
    }
    // 底部操作按钮
    @ViewBuilder
    private func bottomActionButtons() -> some View {
        Grid(tracks: [.fr(1),.fr(1.725)], spacing: 16) {
            Button {
                send(.buyPaperBook)
            } label: {
                Text("购买纸书")
                    .font(.sdBody1.weight(.medium))
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.sdMiddle(background: SDColor.buttonBackGray, foreground: SDColor.text2))
            
            Button {
                send(.startReading)
            } label: {
                Text(confimButtonTitle)
                    
                    
                    .frame(maxWidth: .infinity)
                    
            }
            .buttonStyle(.sdMiddle(background: confimButtonColor))
        }
        .frame(height: 56)

        .padding(.horizontal,16)

        .background {
            Color.white
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    SDLine(.divider)
                }
        }
           
    }
}

// 章节行视图
struct ChapterRowView: View {
    let chapter: SDBookChapter
    let isExpanded: Bool
    let onTap: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                if let id = chapter.id {
                    onTap(id)
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(SDColor.text3)
                        .font(.caption)
                        .opacity(chapter.childs?.isEmpty == false ? 1 : 0)
                        .frame(width: 10)
                    Text(chapter.name ?? "未知章节")
                        .font(.sdBody2)
                        .foregroundColor(SDColor.text1)
                    Spacer()

                    if chapter.tryReadFlag == true {
                        Text("试读")
                            .font(.sdSmall1)
                            .foregroundColor(Color(hex: "#49BA6C"))

                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                    } else {
                        Image("lock")
                    }
                        
                }
            }
            .buttonStyle(.plain)
            .frame(height: 44, alignment: .center)

            
            SDLine(SDColor.divider1)
            // 子章节
            if isExpanded, let childs = chapter.childs, !childs.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(childs, id: \.id) { subChapter in
                        ChapterRowView(
                            chapter: subChapter,
                            isExpanded: isExpanded && (subChapter.id.map { id in
                                isExpanded
                            } ?? false),
                            onTap: onTap
                        )
                        .padding(.leading, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SDBookDetailView(
            store: Store(
                initialState: SDBookDetailReducer.State(id: 110),
                reducer: {
                    SDBookDetailReducer()
                        .dependency(\.bookClient, .liveValue)
                        ._printChanges()
                    
                }
            )
        )
    }
}
extension View {
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

struct FrameRectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct FrameGetter: ViewModifier {

    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ViewFrameKey.self, value: proxy.frame(in: .global))
                }
            )
            .onPreferenceChange(ViewFrameKey.self) { rect in
                print("====\(rect)")

                if rect.integral != self.frame.integral {
                    self.frame = rect
                    print("====\(rect)")
                }
            }
    }
}
