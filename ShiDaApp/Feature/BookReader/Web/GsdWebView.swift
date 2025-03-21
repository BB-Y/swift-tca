import SwiftUI
import WebKit

// MARK: - WebView 封装
struct GsdWebView: UIViewRepresentable {
    let htmlString: String
    let baseURL: URL?
    @State private var menuPosition = CGPoint.zero
    @State private var selectedText = ""
    @State private var showMenu = false
    // 初始化方法（支持自定义 baseURL）
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.minimumFontSize = 12.0
        preferences.javaScriptCanOpenWindowsAutomatically = false
        if #available(iOS 16.0, *) {
            //preferences.setValue(false, forKey: "allowContextMenu")
        }
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.userContentController.add(context.coordinator, name: "clickHandler")
        config.userContentController.add(context.coordinator, name: "selectionHandler")
        config.userContentController.add(context.coordinator, name: "selectionMenu")
        config.userContentController.add(context.coordinator, name: "contextMenu")
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.addInteraction(UIContextMenuInteraction(delegate: context.coordinator))
        
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    func getFullHtmlString() -> String
    {
        var html = """
            <html>
            <head>
            <script>
            document.addEventListener('click', (e) => {
                const rect = e.target.getBoundingClientRect();
                window.webkit.messageHandlers.clickHandler.postMessage({
                    x: e.clientX - rect.left,
                    y: e.clientY - rect.top
                });
            });
            document.addEventListener('selectionchange', () => {
                const selection = getSelectionPath();
                if (selection) {
                    window.webkit.messageHandlers.selectionHandler.postMessage(selection);
                }
            });

            function getSelectionPath() {
                const sel = window.getSelection();
                if (sel.rangeCount === 0) return null;
                
                const range = sel.getRangeAt(0);
                return {
                    start: getNodePath(range.startContainer, range.startOffset),
                    end: getNodePath(range.endContainer, range.endOffset)
                };
            }

            function getNodePath(node, offset) {
                const path = [];
                while (node.parentNode) {
                    path.push(Array.from(node.parentNode.childNodes).indexOf(node));
                    node = node.parentNode;
                }
                return { path: path.reverse(), offset: offset };
            }
            function restoreSelection(data) {
                const startNode = resolveNodePath(data.start.path);
                const endNode = resolveNodePath(data.end.path);
                
                const range = document.createRange();
                range.setStart(startNode, data.start.offset);
                range.setEnd(endNode, data.end.offset);
                
                const sel = window.getSelection();
                sel.removeAllRanges();
                sel.addRange(range);
            }

            function resolveNodePath(pathArray) {
                let node = document.documentElement;
                for (const index of pathArray) {
                    node = node.childNodes[index];
                }
                return node;
            }
            function getSelectionRect() {
                const selection = window.getSelection();
                if (selection.rangeCount === 0) return null;
                
                const range = selection.getRangeAt(0);
                const rect = range.getBoundingClientRect();
                
                return {
                    text: selection.toString(),
                    x: rect.left + window.scrollX,
                    y: rect.top + window.scrollY,
                    width: rect.width,
                    height: rect.height
                };
            }


            </script>
                <style>
                </style>
            </head>
            <body>

            """
        
        return String.init(format: "%@/n%@ </body>\"", html, htmlString)
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 当 htmlString 更新时重新加载内容
        uiView.loadHTMLString(self.getFullHtmlString(), baseURL: baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedText: $selectedText,
                    menuPosition: $menuPosition,
                    showMenu: $showMenu)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler , UIContextMenuInteractionDelegate{
        
        @Binding var selectedText: String
        @Binding var menuPosition: CGPoint
        @Binding var showMenu: Bool
        init(selectedText: Binding<String>,
             menuPosition: Binding<CGPoint>,
             showMenu: Binding<Bool>) {
            _selectedText = selectedText
            _menuPosition = menuPosition
            _showMenu = showMenu
        }
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                  configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return nil
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "contextMenu",
               let data = message.body as? [String: Any] {
                
                // 坐标转换（逻辑像素 -> 物理像素）
                let scale = UIScreen.main.scale
                let x = (data["x"] as? CGFloat ?? 0) * scale
                let y = (data["y"] as? CGFloat ?? 0) * scale
                
                // 动态生成菜单项
               /* var items: [ContextMenuItem] = []
                
                if let text = data["text"] as? String, !text.isEmpty {
                    items.append(ContextMenuItem(
                        id: "copy",
                        title: "复制",
                        icon: "doc.on.doc",
                        action: { UIPasteboard.general.string = text }
                    ))
                }
                
                if let href = data["href"] as? String, !href.isEmpty {
                    items.append(ContextMenuItem(
                        id: "openLink",
                        title: "打开链接",
                        icon: "safari",
                        action: { UIApplication.shared.open(URL(string: href)!) }
                    ))
                }
                
                // 通用操作项
                items.append(ContextMenuItem(
                    id: "highlight",
                    title: "高亮标记",
                    icon: "highlighter",
                    action: { /* 高亮逻辑 */ }
                ))
                
                DispatchQueue.main.async {
                    parent.menuPosition = CGPoint(x: x, y: y)
                    parent.menuItems = items
                    parent.showMenu = items.isEmpty ? false : true
                }*/
        }
            else
            if message.name == "clickHandler",
               let dict = message.body as? [String: CGFloat] {

                // 坐标转换逻辑
                let scaledPoint = CGPoint(
                    x: dict["x"]! * UIScreen.main.scale,
                    y: dict["y"]! * UIScreen.main.scale
                )
                print("clickHandler： \(scaledPoint)")
                //clickPosition = scaledPoint
            }else if message.name == "selectionHandler",
                let data = message.body as? [String: Any] {
                    
                // 存储到 UserDefaults
                print("clickHandler： \(data)")
                UserDefaults.standard.set(data, forKey: "lastSelection")
            }else if message.name == "selectionMenu",
                     let data = message.body as? [String: Any] {
                //UIMenuController.shared.hideMenu()
                // 坐标转换
                let screenScale = UIScreen.main.scale
                let x = (data["x"] as? CGFloat ?? 0) * screenScale
                let y = (data["y"] as? CGFloat ?? 0) * screenScale
                
                DispatchQueue.main.async {
                    self.selectedText = data["text"] as? String ?? ""
                    self.menuPosition = CGPoint(x: x, y: y)
                    self.showMenu = true
                }
            }
        }
        func webView(_ webView: WKWebView,
                   contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo,
                   completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
            completionHandler(nil) // 返回nil禁用默认菜单
        }
        // 可在此处处理导航事件
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            //恢复选中状态
            guard let selectionData = UserDefaults.standard.data(forKey: "lastSelection") else { return }
                
                let script = """
                const data = \(String(data: selectionData, encoding: .utf8)!);
                restoreSelection(data);
                """
                webView.evaluateJavaScript(script)
            
            /*let js = """
                    // 点击事件监听
                    
                    """
                webView.evaluateJavaScript(js)*/
        }
    }
}

