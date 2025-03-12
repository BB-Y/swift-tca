//
//  SDHomeSectionView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/10.
//

import SwiftUI

struct SDHomeSectionView: View {
    let item: SDResponseHomeSection
    var onItemTap: ((SDResponseHomeListItem) -> Void)? // 添加点击回调
        var onTitleTap: ((SDResponseHomeSection) -> Void)? // 添加点击回调

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var bannerHeight: CGFloat {
        (UIScreen.main.bounds.width - 32) / aspect

    }
    var aspect: CGFloat {
        343/140
    }
    var hasSubTitle: Bool {
        switch item.style {
        case .headerBanner, .recommendTypeB, .recommendTypeE:
            return false
        default:
            return true
        }
    }
    
    var subTitle: String?{
        if hasSubTitle {
            return item.memo
        } else {
            return nil
        }
    }
    
    var dataList: [SDResponseHomeListItem] {
        let list = item.dataList ?? []
        switch item.style {
        case .headerBanner, .recommendTypeB, .recommendTypeE:
            return list
        case .middleBanner:
            return list
        case .recommendTypeA:
            return Array(list.prefix(3))
        case .recommendTypeC, .recommendTypeD:
            return Array(list.prefix(6))
        case .recommendTypeG:
            return Array(list.prefix(4))

        case .bookSectionSliding:
            return Array(list.prefix(3))

        case .bookSectionFixed:
            return list
        case .none:
            return list

        }
        
    }
    // 添加通用的 TitleView 创建方法
      private func createTitleView(withPadding: Bool = true) -> some View {
          SDHomeTitleView(item.name ?? "", subTitle) {
                          onTitleTap?(item) // 触发标题点击回调

          }
          .padding(.horizontal, withPadding ? 16 : 0)
      }
    // 头部横幅视图
    private var headerBannerView: some View {
        SDBannerView(data: dataList) { item in
            WebImage(url: item.dataCover?.url)
                .resizable()
                .aspectRatio(aspect, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                .padding(.horizontal, 16)
                .onTapGesture {
                    onItemTap?(item)
                }
        }
        .frame(height: bannerHeight)
    }
    
    // 中部横幅视图
    private var middleBannerView: some View {
        EmptyView() 
    }
    
    // 推荐位A型视图,固定3个
    private var recommendTypeAView: some View {
        VStack(spacing: 16) {
            createTitleView(withPadding: false)
            HStack(alignment: .top,spacing: 0) {
                ForEach(0..<dataList.count, id:\.self) { index in
                    let item = dataList[index]
                    SDHomeSectionItemView(item.dataCover ?? "", style: .image, title: item.dataName)
                        .onTapGesture {
                            onItemTap?(item)
                        }
                        
                    if index < dataList.count - 1 {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)

    }
    
    // 推荐位B型视图
    private var recommendTypeBView: some View {
        VStack(spacing: 10) {
            createTitleView()
            .padding(.horizontal, 16)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 24) {
                    ForEach(dataList) { item in
                        
                        SDHomeSectionItemView(item.dataCover ?? "", style: .image, title: item.dataName)
                            .onTapGesture {
                                onItemTap?(item)
                            }
                            
                    }
                }
                .padding(.horizontal, 16)

            }
        }
        
    }
    
    // 推荐位C型视图
    private var recommendTypeCView: some View {
        VStack(spacing: 16) {
            createTitleView(withPadding: false)
            
            
            SDLazyVGrid(data: 0..<dataList.count, columns: 3, width: 88, hAlignment: .top) {index in
                let item = dataList[index]
                SDHomeSectionItemView(item.dataCover ?? "", style: .image, title: item.dataName)
                    .onTapGesture {
                        onItemTap?(item)
                    }
            }
            .frame(maxWidth: .infinity)
            

            //.padding(.horizontal, 16)
            

            

        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
    
    // 推荐位D型视图
    private var recommendTypeDView: some View {
        VStack(spacing: 16) {
            createTitleView(withPadding: false)
            SDLazyVGrid(data: 0..<dataList.count, columns: 3, width: 88, hAlignment: .top) {index in
                let item = dataList[index]
                SDHomeSectionItemView(item.dataCover ?? "", style: .image)
                    .onTapGesture {
                        onItemTap?(item)
                    }
            }
            .frame(maxWidth: .infinity)
            
            

            

        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
    
    // 推荐位E型视图
    private var recommendTypeEView: some View {
        VStack(spacing: 10) {
            createTitleView()
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(dataList) { item in
                        
                        SDHomeSectionItemView(item.dataCover ?? "", style: .imageSmall)
                            .onTapGesture {
                                onItemTap?(item)
                            }
                    }
                }
                .padding(.horizontal, 16)

            }
        }
    }
    
    // 推荐位G型视图
    private var recommendTypeGView: some View {
        VStack(spacing: 16) {
            createTitleView(withPadding: false)
            SDLazyVGrid(data: 0..<dataList.count, columns: 2, width: 144, hAlignment: .top) {index in
                let item = dataList[index]
                SDHomeSectionItemView(item.dataCover ?? "", style: .liveVideo, title: item.dataName)
                    .onTapGesture {
                        onItemTap?(item)
                    }
            }
            .frame(maxWidth: .infinity)
            

            

        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
    
    // 图书滑动视图
    private var bookSectionSlidingView: some View {
        VStack(spacing: 16) {
            createTitleView()
            VStack(spacing: 24) {
                ForEach(0..<2) { row in
                    SDAutoScrollView(
                        itemCount: dataList.count,
                        itemWidth: 88,
                        spacing: 16,
                        initialOffset: row == 0 ? 0 : -30
                    ) { index in
                        let item = dataList[index]
                        SDHomeSectionItemView(item.dataCover ?? "", style: .image)
                            .frame(width: 88, height: 130)
                            .onTapGesture {
                                onItemTap?(item)
                            }
                    }
                    .frame(height: 130)
                }
            }


        }
        .padding(.vertical,16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)

    }
    
    // 固定图书视图
    private var shoolSectionSlidingView: some View {
        VStack {
            createTitleView()
            VStack(spacing: 16) {
                ForEach(0..<2) { row in
                    SDAutoScrollView(
                        itemCount: dataList.count,
                        itemWidth: 72,
                        initialOffset: row == 0 ? 0 : -30
                    ) { index in
                        let item = dataList[index]
                        SDHomeSectionItemView(item.dataCover ?? "", style: .circle)
                            .frame(width: 72, height: 72)
                            .onTapGesture {
                                onItemTap?(item)
                            }
                    }
                    .frame(height: 72)
                }
            }
        }
        .padding(.vertical,16)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)

        
    }
    
    var body: some View {
        switch item.style {
        case .headerBanner:
            headerBannerView
        case .middleBanner:
            EmptyView()
        case .recommendTypeA:
            recommendTypeAView
        case .recommendTypeB:
            recommendTypeBView
        case .recommendTypeC:
            recommendTypeCView
        case .recommendTypeD:
            recommendTypeDView
        case .recommendTypeE:
            recommendTypeEView
        case .recommendTypeG:
            recommendTypeGView
        case .bookSectionSliding:
            if item.dataList?.first?.dataType == .cooperativeSchool {
                shoolSectionSlidingView
            } else {
                bookSectionSlidingView
            }
            
        case .bookSectionFixed:
            EmptyView()
            
        case .none:
            EmptyView()
        }
    }
}

#Preview {
    var data: SDResponseHomeSection{
        var data = SDResponseHomeSection.mock
        data.style = .recommendTypeC
        return data
    }
    
    ScrollView {
        SDHomeSectionView(item: data)
            
            
    }
    .background(        SDColor.background
)
    
}
