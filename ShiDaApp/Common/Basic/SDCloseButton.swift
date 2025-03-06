//
//  SDCloseButton.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDCloseButton: View {
    var action: () -> Void
    var size: CGFloat = 24
    
    init(size: CGFloat = 24, action: @escaping () -> Void) {
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image("close")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    SDCloseButton {
        print("Close button tapped")
    }
}