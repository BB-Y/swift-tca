//
//  SDLine.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI

struct SDLine: View {
    let color: Color
    let axial: Edge.Set
    let weight: CGFloat
    init(_ color: Color, axial: Edge.Set = .horizontal, weight: CGFloat = 1) {
        self.color = color
        self.axial = axial
        self.weight = weight
    }
    var body: some View {
        if axial == .horizontal {
            color
                .frame(height: weight)
        } else if axial == .vertical {
            color
                .frame(width: weight)
        }
        
    }
}

#Preview {
    SDLine(.red)
}
