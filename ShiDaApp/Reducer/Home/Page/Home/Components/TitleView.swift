//
//  TitleView.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct TitleView: View {
    let title: String
    let subTitle: String
    init(_ title: String, _ subTitle: String = "") {
        self.title = title
        self.subTitle = subTitle
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title2)
                    .lineLimit(1)

                Spacer()
                ArrowView()
            }
            if subTitle.isEmpty == false {
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                    .lineLimit(2)
            }
        }
        
        
        
    }
}

#Preview {
    TitleView("十四五规划精品教材", "本教材紧扣国家“十四五”规划发展脉络，精心打造而成。内容全面涵盖了“十四五”期..")
}
