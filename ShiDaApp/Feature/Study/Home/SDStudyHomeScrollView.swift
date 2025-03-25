//
//  SDStudyHomeScrollView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/24.
//

import SwiftUI

struct SDStudyHomeScrollView<Content: View>: View {
    @Binding var isTop: Bool
    
    
    @ViewBuilder let content: () -> Content
    var body: some View {
        ScrollView {
            
            LazyVStack(spacing: 16) {
                
                content()
            }
            .padding(.vertical, 16)
            .overlay(alignment: .top) {
                GeometryReader { proxy in
                    Color.blue
                        .frame(height: 0)
                        .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scrollview")).minY)
                    
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(SDColor.background)
        .coordinateSpace(name: "scrollview")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
            
            if isTop {
                if offset > 0 {
                    withAnimation {
                        isTop = false
                        
                    }
                    
                    //id2 += 1
                }
            } else {
                if offset < 0 {
                    withAnimation {
                        isTop = true
                        
                    }
                }
            }
            
        }
    }
}

//#Preview {
//    SDStudyHomeScrollView()
//}
