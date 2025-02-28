//
//  SDSpacer.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDVSpacer: View {
    private var height: CGFloat? = nil
    init() {
        
    }
    init(_ height: CGFloat?) {
        self.height = height
    }
    var body: some View {
        if height == nil {
            Spacer()
        } else {
            Spacer().frame(height: height ?? 0)
        }
    }
}

struct SDHSpacer: View {
    private var width: CGFloat? = nil
    init() {
    }
    init(_ width: CGFloat?) {
        self.width = width
    }
    var body: some View {
        if width == nil {
            Spacer()
        } else {
            Spacer().frame(width: width ?? 0)
        }
    }
}
