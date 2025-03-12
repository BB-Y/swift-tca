//
//  SDLargeTitleView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDLargeTitleView: View {
    let text: String
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(SDColor.text1)
            .frame(maxWidth: .infinity, alignment: .leading)
            
    }
}

#Preview {
    SDLargeTitleView("1213")
}
