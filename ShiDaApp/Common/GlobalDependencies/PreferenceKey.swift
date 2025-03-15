//
//  PreferenceKey.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/14.
//

import Foundation
import SwiftUI


struct ViewSizeKey: PreferenceKey {
    static var defaultValue = CGSize.zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        //value = nextValue()
    }
}

struct ViewFrameKey: PreferenceKey {
    static var defaultValue = CGRect.zero
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        value = nextValue()
//    }
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        let next = nextValue()
        
        if next != .zero {
            value = next
        }
        
    }

}
// 用于传递滚动偏移量的 PreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
