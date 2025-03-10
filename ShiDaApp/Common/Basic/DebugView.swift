//
//  DebugView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/10.
//

import SwiftUI

extension View {
    func debug() -> some View {
        self.border(Color.red, width: 3)
    }
}
