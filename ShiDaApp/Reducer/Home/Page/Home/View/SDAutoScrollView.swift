import SwiftUI

struct SDAutoScrollView<Content: View>: View {
    let content: (Int) -> Content
    let itemCount: Int
    let itemWidth: CGFloat
    let spacing: CGFloat
    let autoScrollInterval: TimeInterval
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    let initialOffset: CGFloat // 添加初始偏移量属性
    
    init(
        itemCount: Int,
        itemWidth: CGFloat,
        spacing: CGFloat = 16,
        autoScrollInterval: TimeInterval = 3.0,
        initialOffset: CGFloat = 0, // 添加初始偏移参数
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.content = content
        self.itemCount = itemCount
        self.itemWidth = itemWidth
        self.spacing = spacing
        self.autoScrollInterval = autoScrollInterval
        self.initialOffset = initialOffset
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = (itemWidth + spacing) * CGFloat(itemCount)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    // 前面补充一组
                    ForEach(0..<itemCount, id: \.self) { index in
                        content(index)
                            .frame(width: itemWidth)
                    }
                    // 主要内容
                    ForEach(0..<itemCount, id: \.self) { index in
                        content(index)
                            .frame(width: itemWidth)
                    }
                    // 后面补充一组
                    ForEach(0..<itemCount, id: \.self) { index in
                        content(index)
                            .frame(width: itemWidth)
                    }
                }
                .offset(x: offset + dragOffset + initialOffset) // 添加 initialOffset
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            isDragging = true
//                            dragOffset = value.translation.width
//                        }
//                        .onEnded { value in
//                            isDragging = false
//                            offset += dragOffset
//                            dragOffset = 0
//                            
//                            let targetOffset = round(offset / -(itemWidth + spacing)) * (itemWidth + spacing)
//                            withAnimation(.easeOut(duration: 0.3)) {
//                                offset = targetOffset
//                            }
//                            
//                            // 处理循环
//                            if -offset >= totalWidth * 2 {
//                                offset += totalWidth
//                            } else if -offset < totalWidth {
//                                offset -= totalWidth
//                            }
//                            
//                            startAutoScroll()
//                        }
//                )
            }
            .onAppear {
                offset = -totalWidth
                startAutoScroll()
            }
            .onDisappear {
                stopAutoScroll()
            }
        }
    }
    
    @State private var autoScrollTask: Task<Void, Never>?
    
    private func startAutoScroll() {
        stopAutoScroll()
        
        autoScrollTask = Task {
            while !isDragging && !Task.isCancelled {
                let targetOffset = offset - (itemWidth + spacing)
                withAnimation(.linear(duration: autoScrollInterval)) {
                    offset = targetOffset
                }
                
                let totalWidth = (itemWidth + spacing) * CGFloat(itemCount)
                if -offset >= totalWidth * 2 {
                    offset += totalWidth
                }
                
                try? await Task.sleep(nanoseconds: UInt64(autoScrollInterval * 1_000_000_000))
            }
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTask?.cancel()
        autoScrollTask = nil
    }
}

#Preview {
    VStack(spacing: 16) {
        ForEach(0..<2) { row in
            SDAutoScrollView(
                itemCount: 8,
                itemWidth: 60,
                spacing: 16,
                autoScrollInterval: 3.0,
                initialOffset: row == 0 ? 0 : -100 // 第二行偏移 100 点
            ) { index in
                Circle()
                    .fill(Color(hue: Double(index) / 8.0, saturation: 0.7, brightness: 0.9))
                    .frame(height: 60)
            }
            .frame(height: 80)
        }
    }
    .padding()
    .background(Color(.systemGray6))
}
