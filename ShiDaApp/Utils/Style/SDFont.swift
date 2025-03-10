//
//  SDFont.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import Foundation
import SwiftUICore

//Regular (400), Medium (500), Bold (600)
extension Font {
    /// 28
    static let sdLargeTitle: Font = .system(size: 28, weight: .regular)
    
    /// 20
    static let sdTitle: Font = .system(size: 20, weight: .regular)
    ///18
    static let sdTitle1: Font = .system(size: 18, weight: .regular)

    /// 16
    static let sdBody1: Font = .system(size: 16, weight: .regular)
    /// 15
    static let sdBody2: Font = .system(size: 15, weight: .regular)

    /// 14
    static let sdBody3: Font = .system(size: 14, weight: .regular)
    
    /// 13
    static let sdBody4: Font = .system(size: 13, weight: .regular)

    /// 12
    static let sdSmall1: Font = .system(size: 12, weight: .regular)
}
