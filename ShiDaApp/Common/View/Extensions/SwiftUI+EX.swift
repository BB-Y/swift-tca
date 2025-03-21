//
//  SwiftUI+EX.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/1.
//

import Foundation
import SwiftUI
import UIKit
// MARK: - backport
extension View {
    @ViewBuilder func sdSheetBackground<Content: View>(_ content: () -> Content) -> some View {
        if #available(iOS 16.4, *) {
            self.presentationBackground(content: content)
        } else {
            self.background(content: content)
        }
    }
}
extension View {
    @ViewBuilder func sdTint(_ color: Color) -> some View {
        if #available(iOS 15, *) {
            tint(color)
        } else {
            accentColor(color)
        }
    }
}
extension View {
    func hideKeyboardWhenTap() -> some View {
        self.contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
            }
    }
    
}
extension View {
    @ViewBuilder func hidden(_ hide: Bool) -> some View {
        if hide {
            hidden()
        } else {
            self
        }
    }
}
extension View {
    @ViewBuilder func hideToolBar() -> some View {
        if #available(iOS 16, *) {
            self.toolbar(.hidden, for: .tabBar)
        } else {
            self
        }
    }
}
extension View {
    @inlinable
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        
        body(&result)
        
        return result
    }
    
    /// Returns a type-erased version of `self`.
    @inlinable
    public func eraseToAnyView() -> AnyView {
        return .init(self)
    }
}




extension Int: @retroactive Identifiable {
    public var id: Int {
        self
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension RandomAccessCollection where Index == Int {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
extension ForEach {
    
    public init<T: RandomAccessCollection>(
        data: T,
        content: @escaping (T.Index, T.Element) -> Content
    ) where T.Element: Identifiable, T.Element: Hashable, Content: View, Data == [(T.Index, T.Element)], ID == T.Element  {
        self.init(Array(zip(data.indices, data)), id: \.1) { index, element in
            content(index, element)
        }
    }
}


extension View {
    @ViewBuilder func sdListSectionSpacing(_ spacing: CGFloat) -> some View {
        if #available(iOS 17, *) {
            self.listSectionSpacing(spacing)
        } else {
            self
        }
    }
    
    
    @ViewBuilder func sdContentMargins(_ spacing: CGFloat) -> some View {
        if #available(iOS 17, *) {
            self.contentMargins(.horizontal, 50)
        } else {
            self
        }
    }
}

