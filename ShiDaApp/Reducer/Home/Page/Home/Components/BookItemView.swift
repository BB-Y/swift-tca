//
//  BookItemView.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct BookItemView: View {
    var body: some View {
        VStack {
            Color.blue
                .aspectRatio(CGSize(width: 88, height: 130), contentMode: .fit)
                //.frame(width: 88)
                .overlay{
                    Image("book1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
                .clipped()

            Text("不被大风吹倒莫言新书！")
                .font(.subheadline)
                .lineLimit(2)
        }
        .frame(width: 88)
        

    }
}

#Preview {
    VStack {
        Text("1212212")
        BookItemView()
    }
}
