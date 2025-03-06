//
//  LazyV.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct LazyV: View {
//    let grid: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 5)
    let grid: [GridItem] = [
//        GridItem(.fixed(88), spacing: 0),
//        GridItem(.flexible(), spacing: 0),
        GridItem(.fixed(88), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.fixed(88), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.fixed(88), spacing: 0)
    ]
    let rows = Int(10/3)
    var counts: Int {
        rows*3
    }
    var body: some View {
        LazyVGrid(columns: grid, spacing: 30) {
            ForEach(0..<counts, id:\.self) { index in
                if (index)%5%2 == 0 {
                    BookItemView()
                }
                else {
                    Spacer()
                    //Color.blue
//                    Spacer(minLength: 1)
//                        .frame(width: 1,height: 50)
//                        .background(Color.yellow)
                }
               
            }
        }
        .padding(.horizontal,0)
        .background(Color.red)
    }
}

#Preview {
    LazyV()
}
