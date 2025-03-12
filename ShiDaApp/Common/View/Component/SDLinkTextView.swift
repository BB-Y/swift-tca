//
//  SDLinkTextView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDLinkTextView: View {
    enum TextSegment {
        case text(String)
        case link(String, url: String)
    }
    struct URL: Identifiable {
        var string: String
        var id: String { string }
    }
    let segments: [TextSegment]
    let onLinkTapped: ((String) -> Void)?
    @State var url: URL?  = nil
    @Environment(\.dismiss) var dismiss
    init(
        segments: [TextSegment],
        onLinkTapped: ((String) -> Void)? = nil
    ) {
        self.segments = segments
        self.onLinkTapped = onLinkTapped
    }
    
    var body: some View {
        Text(attributedString)
            .environment(\.openURL, OpenURLAction { url in
                if self.onLinkTapped != nil {
                    self.onLinkTapped?(url.absoluteString)
                } else {
                    self.url = URL(string: url.absoluteString)
                }
                
                return .handled
            })
            .sheet(item: $url, content: { item in
                SDWebView(url: item.string) {
                    self.url = nil
                }
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
            })
        
    }
    
    private var attributedString: AttributedString {
        var result = AttributedString()
        
        for segment in segments {
            switch segment {
            case .text(let text):
                if let textAttr = try? AttributedString(markdown: text) {
                    result.append(textAttr)
                } else {
                    var plainText = AttributedString(text)
                    result.append(plainText)
                }
            case .link(let text, let url):
                if let linkAttr = try? AttributedString(markdown: "[\(text)](\(url))") {
                    result.append(linkAttr)
                }
            }
        }
        
        return result
    }
}
