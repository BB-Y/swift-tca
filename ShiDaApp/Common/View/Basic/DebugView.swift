//
//  DebugView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/10.
//

import SwiftUI

extension View {
    func debug(_ color: Color = .red) -> some View {
        self.border(color, width: 1)
    }
}
