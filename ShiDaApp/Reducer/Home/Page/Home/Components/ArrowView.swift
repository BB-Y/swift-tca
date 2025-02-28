//
//  ArrowView.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct ArrowView: View {
    var body: some View {
        Image("arrow")
            .scaledToFill()
            .contentShape(Rectangle())
    }
}

#Preview {
    ArrowView()
}
