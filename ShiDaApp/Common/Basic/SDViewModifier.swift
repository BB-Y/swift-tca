//
//  SDViewModifier.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDTextFieldWithClearButtonModefier : ViewModifier {
    @Binding var text: String
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .onTapGesture {
                        text = ""
                    }
            }
            
        }
        
    }
    
}
