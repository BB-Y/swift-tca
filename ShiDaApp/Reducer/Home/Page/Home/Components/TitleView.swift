//
//  TitleView.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct SDHomeTitleView: View {
    let title: String
    let subTitle: String?
    let onTapped: () -> Void
    init(_ title: String, _ subTitle: String? = nil, onTapped: @escaping () -> Void) {
        self.title = title
        self.subTitle = subTitle
        self.onTapped = onTapped
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.sdTitle1)
                    .lineLimit(1)
                    .foregroundStyle(SDColor.text1)

                Spacer()
                Button {
                    
                } label: {
                    ArrowView()
                }

                
            }
            if let subTitle, subTitle.isEmpty == false {
                Text(subTitle)
                    .font(.sdBody4)
                    .foregroundStyle(SDColor.text3)
                    .lineLimit(2)
            }
        }
        
        
        
    }
}

#Preview {
    SDHomeTitleView("十四五规划精品教材", "本教材紧扣国家“十四五”规划发展脉络，精心打造而成。内容全面涵盖了“十四五”期..", onTapped: {})
}
