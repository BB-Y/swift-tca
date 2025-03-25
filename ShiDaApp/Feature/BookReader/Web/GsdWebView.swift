import SwiftUI
import WebKit

// MARK: - WebView 封装
struct GsdWebView: UIViewControllerRepresentable {
    // 初始化方法（支持自定义 baseURL）
    var htmlContent : String = ""
    @Perception.Bindable var storePage: StoreOf<BookPageReducer>
    
    func makeUIViewController(context: Context) -> UIViewController {
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
        // 禁用横向滚动条指示器
        webView.scrollView.showsHorizontalScrollIndicator = false

        // 禁用弹性效果（防止拖拽越界）
        webView.scrollView.bounces = false

        // 可选：锁定滚动方向（仅允许垂直滚动）
        webView.scrollView.isDirectionalLockEnabled = true
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        webView.navigationDelegate = context.coordinator
        
        webView.scrollView.delegate = context.coordinator
        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        panGestureRecognizer.delegate = context.coordinator
        webView.addGestureRecognizer(panGestureRecognizer)
        
        
        
        webView.loadHTMLString(self.getFullHtmlString(), baseURL: Bundle.main.resourceURL)
                
        // 返回一个 UIViewController 来管理 WKWebView
        let viewController = UIViewController()
        viewController.view = webView
                
        return viewController
    }
    func getFullHtmlString() -> String
    {
        let html = """
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
                <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
                <style>
                    /* 隐藏横向溢出 */
                    body {
                        overflow-x: hidden !important;
                        max-width: 100% !important; 
                    }
                </style>
            </head>
            <body>

            """
        
        return String.init(format: "%@%@ </body>", html, htmlContent)
    }
    //func updateUIView(_ uiView: WKWebView, context: Context) {
        // 当 htmlString 更新时重新加载内容
       
   // }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            // 当更新时，你可以在此处更新网页内容或进行其他操作
    }
    func makeCoordinator() -> Coordinator {
        Coordinator( store:storePage)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler , UIContextMenuInteractionDelegate,
                       UIGestureRecognizerDelegate,UIScrollViewDelegate {
        var m_webView: WKWebView?
        @Perception.Bindable var storePage: StoreOf<BookPageReducer>
        
//        let _store: StoreOf<SDBookReaderReducer>
//        
        init( store: StoreOf<BookPageReducer>) {
            storePage = store
        }
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                  configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return nil
        }
        // 手势识别代理方法，允许传递滑动事件
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if m_webView == nil
            {
                return true
            }
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = panGesture.velocity(in: m_webView!)
                if velocity.x < -50  {  // 如果是垂直滑动
                    
                    storePage.send(BookPageReducer.Action.turnNextPage)
                    //parent.nextPage()
                }else if velocity.x > 100
                {
                    storePage.send(BookPageReducer.Action.turnPrePage)
                }
            }
            return true
        }
        // 滚动位置检查，滚动到顶部或底部时触发翻页
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y <= 0 {
                // 滚动到顶部
               // parent.previousPage()
            } else if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                // 滚动到底部
                //parent.nextPage()
            }
        }
        // 处理滑动事件进行翻页
        @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
            let velocity = gestureRecognizer.velocity(in: m_webView)
            if abs(velocity.y) > abs(velocity.x) {
                if velocity.y < 0 {
                    // 向上滑动，翻到下一页
                    //parent.nextPage()
                } else {
                    // 向下滑动，翻到上一页
                    //parent.previousPage()
                }
            }
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
                
                storePage.send(BookPageReducer.Action.showMenu)
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
                   // self.selectedText = data["text"] as? String ?? ""
                   // self.menuPosition = CGPoint(x: x, y: y)
                   // self.showMenu = true
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
//            guard let selectionData = UserDefaults.standard.data(forKey: "lastSelection") else { return }
//                
//                let script = """
//                const data = \(String(data: selectionData, encoding: .utf8)!);
//                restoreSelection(data);
//                """
//                webView.evaluateJavaScript(script)
            
            
//            let script = "document.documentElement.style.overflowX = 'hidden'; document.body.style.overflowX = 'hidden';"
//            webView.evaluateJavaScript(script, completionHandler: nil)
            /*let js = """
                    // 点击事件监听
                    
                    """
                webView.evaluateJavaScript(js)*/
            
            m_webView = webView
        }
    }
}

