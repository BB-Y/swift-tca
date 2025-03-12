//
//  SDWebView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI
import WebKit

// 用于WebView的标识模型
struct WebViewItem: Identifiable {
    let id = UUID()
    let url: String
}

// WebView组件，包含关闭回调
struct SDWebView: View {
    let url: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            WebViewRepresentable(urlString: url)
        }
    }
}

// WebView的UIKit包装器
struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        // 可以在这里处理WebView的导航事件
    }
}