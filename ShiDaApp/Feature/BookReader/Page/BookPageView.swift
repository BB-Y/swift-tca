//
//  BookPageView.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/21.
//

import SwiftUI
import WebKit

// MARK: - 核心翻页容器
struct BookPageView: View {
    @Perception.Bindable var store: StoreOf<SDBookReaderReducer>
    @Perception.Bindable var storePage: StoreOf<BookPageReducer>
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showMenu : Bool = false
    
    // 翻页动画配置
    enum PageStyle {
        case slide     // 滑动翻页
        case cover     // 覆盖翻页
        case simulate  // 仿真翻页
    }
    @State private var pageStyle: PageStyle = .slide

    
    var body: some View {
        VStack {
            
            // 页面容器
            ZStack {
                ForEach(0..<store.state.pageConent.count, id: \.self) { index in
                    GsdWebView(htmlContent: store.state.pageConent[index].content ?? "", storePage: storePage)
                        .visualEffect(index: index, totalPage: store.state.pageConent.count, pageStyle: pageStyle,currentPageIndex: currentIndex)
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        //handleSwipe(translation: value.translation.width)
                    }
            )
            .onChange(of: storePage.state.nextPage) { newValue in
                handleSwipe(translation:-200)
            }
            .onChange(of: storePage.state.prePage) { newValue in
                handleSwipe(translation:200)
            }
        }
    }
    
    // 处理滑动结束逻辑
    private func handleSwipe(translation: CGFloat) {
        withAnimation(.spring(dampingFraction: 0.7)) {
            if translation < -100 { // 向左滑动
                goNext()
            } else if translation > 100 { // 向右滑动
                goPrevious()
            }
        }
    }
    
    // 下一页
    private func goNext() {
        //pages = pages.rotatedRight() // 循环复用页面
        //var nextCatalogId = store.state.catalogId
        let nextCatalogId = store.state.getNextMainCatalogId(catalogId: store.state.catalogId)
        if nextCatalogId == -1
        {
            return
        }
        let m  = store.state.getChapterContent(catalogId: nextCatalogId)
        
        
        if m == nil
        {
            store.state.catalogId = nextCatalogId;
            store.state.bTurnPageNext = true
            store.send(SDBookReaderReducer.Action.fetchChapterDetail(nextCatalogId))
        }else
        {
            //需要要跳转到目录 是不是 子目录 当前已经存在的
            // 这个循环要跳出 一个html 里面有多个 目录的情况
            store.state.catalogId = nextCatalogId;
            let newNextCatalogId = store.state.getNextMainCatalogId(catalogId: nextCatalogId)
            if newNextCatalogId != -1
            {
                let nm = store.state.getChapterContent(catalogId: newNextCatalogId)
                if nm == nil
                {
                    store.state.bTurnPageNext = true
                    store.send(SDBookReaderReducer.Action.fetchChapterDetail(newNextCatalogId))
                    
                }
            }
                
            
        }
        store.errorMessage = nil
        currentIndex = currentIndex + 1
    }
    
    // 上一页
    private func goPrevious() {
        //pages = pages.rotatedLeft()
        
        let preCatalogId = store.state.getPreMainCatalogId(catalogId: store.state.catalogId)
        if preCatalogId == -1
        {
            return
        }
        let m = store.state.getChapterContent(catalogId: preCatalogId)
        
        if m == nil
        {
            store.state.bTurnPageNext = false
            store.state.catalogId = preCatalogId;
            store.send(SDBookReaderReducer.Action.fetchChapterDetail(preCatalogId))
        }else
        {
            store.state.catalogId = preCatalogId;
            let newPreCatalogId = store.state.getPreMainCatalogId(catalogId: preCatalogId)
            if newPreCatalogId != -1
            {
                let nm = store.state.getChapterContent(catalogId: newPreCatalogId)
                if nm == nil
                {
                    store.state.bTurnPageNext = false
                    store.send(SDBookReaderReducer.Action.fetchChapterDetail(newPreCatalogId))
                }
            }
        }
        store.errorMessage = nil
        currentIndex = currentIndex - 1
    }
}

// MARK: - 页面视觉特效
extension View {
    @ViewBuilder
    func visualEffect(index: Int, totalPage : Int, pageStyle: BookPageView.PageStyle, currentPageIndex : Int) -> some View {
        switch pageStyle {
        case .slide:
            self.offset(x: offsetForSlide(index: index, totalPage : totalPage, currentPageIndex: currentPageIndex))
                .zIndex(currentPageIndex == index ? 1 : 0)
            
        case .cover:
            self.scaleEffect(currentPageIndex == index ? 1 : 0.9)
                .opacity(currentPageIndex == index ? 1 : 0.8)
                .offset(x: offsetForCover(index: index))
                .zIndex(currentPageIndex == index ? 1 : 0)
            
        case .simulate:
            self.rotation3DEffect(
                .degrees(rotationAngleForSimulate(index: index)),
                axis: (x: 0, y: 1, z: 0),
                anchor: index == 2 ? .leading : .trailing
            )
            .offset(x: offsetForCover(index: index))
            .zIndex(zIndexForSimulate(index: index))
        }
    }
    
    // 滑动模式偏移计算
    private func offsetForSlide(index: Int, totalPage : Int, currentPageIndex : Int) -> CGFloat {
        let baseOffset = UIScreen.main.bounds.width
        if currentPageIndex == index
        {
            return 0
        }else if currentPageIndex > index {
            return -baseOffset
        }
        return baseOffset
    }
    
    // 覆盖模式偏移计算
    private func offsetForCover(index: Int) -> CGFloat {
        index == 2 ? UIScreen.main.bounds.width : 0
    }
    
    // 仿真模式3D旋转
    private func rotationAngleForSimulate(index: Int) -> Double {
        switch index {
        case 0: return 0
        case 1: return 0
        case 2: return 0
        default: return 0
        }
    }
    
    // 仿真模式层级控制
    private func zIndexForSimulate(index: Int) -> Double {
        index == 1 ? 2 : 1
    }
}
