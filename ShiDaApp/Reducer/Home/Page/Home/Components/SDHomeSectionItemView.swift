//
//  BookItemView.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct SDHomeSectionItemView: View {
    let url: String
    
    let style: SectionItemStyle
    let title: String?
    init(_ url: String, style: SectionItemStyle, title: String? = nil) {
        self.url = url
        self.style = style
        self.title = title
    }
    enum SectionItemStyle {
        
        case image
        case imageSmall
        case liveVideo
        case circle
        
        var size: CGSize {
            switch self {
            case .image:
                return CGSize(width: 88, height: 130)
            case .imageSmall:
                return CGSize(width: 72, height: 106)
            case .liveVideo:
                return CGSize(width: 144, height: 100)
            case .circle:
                return CGSize(width: 72, height: 72)

            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if style == .circle {
                Circle()
                    .frame(width: style.size.width, height: style.size.height)

                    .overlay {
                        image
                    }
                
                    .clipShape(Circle())
                    
            } else {
                image
                    .clipped()
                    .border(SDColor.divider, width: 1)
            }
           
                //.frame(width: style.size.width)
            
            
            if let title {
                Text(title)
                    .font(.sdBody4)
                    .foregroundStyle(SDColor.text1)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(width: style.size.width)
        
        

    }
    var image: some View {
//        Color.gray
//            .aspectRatio(style.size, contentMode: .fill)
//            .overlay{
//                
//                
//            }
        WebImage(url: url.url)
            .resizable()
            .scaledToFill()
            .frame(width: style.size.width, height: style.size.height)
            
    }
}

#Preview {
    HStack(spacing: 0) {
        
        SDHomeSectionItemView("http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png", style: .image, title: "245534534535345")
        //Color.red
        Spacer()
        SDHomeSectionItemView("http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png", style: .image, title: "245534534535345")
        //Color.red
        Spacer()

        SDHomeSectionItemView("http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png", style: .image, title: "245534534535345")
    }
}


