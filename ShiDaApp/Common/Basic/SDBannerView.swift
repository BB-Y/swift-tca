import SwiftUI


struct SDBannerView<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable & Hashable, Content: View {
    let data: Data
    let content: (Data.Element) -> Content
    @State private var currentIndex: Int = 0
    
    let time: TimeInterval = 3
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18.0, *) {
                ACarousel(data,
                          id: \.self,
                          index: $currentIndex,
                          spacing: 0,
                          headspace: 0,
                          sidesScaling: 1,
                          isWrap: true,
                          autoScroll: .active(time)) { item in
                    content(item)
                }
                
            } else {
                ACarousel(data,
                          id: \.self,
                          index: $currentIndex,
                          spacing: 0,
                          headspace: 0,
                          sidesScaling: 1,
                          isWrap: true,
                          autoScroll: .active(3)) { item in
                    content(item)
                }
            }
            
            // Add PageControl
            HStack(spacing: 8) {
                ForEach(0..<Array(data).count, id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? Color.white : Color.white.opacity(0.5))
                        .frame(width: currentIndex == index ? 6 : 4, height: currentIndex == index ? 6 : 4)
                        .animation(.spring(), value: currentIndex)
                }
            }
            .padding(5, 3)
            .background {
                Color.black.opacity(0.2)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 6)
        }
    }
}

@available(iOS 18.0, *)


struct CustomCarousel<Content: View>: View {
    @Binding var activeIndex: Int
    @ViewBuilder var content: Content
    @State private var scrollPosition: Int?
    @State private var offsetBasedPosition: Int = 0
    @State private var isSettled: Bool = false
    @State private var isScroll: Bool = false
    @GestureState private var isHoldingScreen: Bool = false
    @State private var timer = Timer.publish(every: autoScrollDuration, on: .main, in: .default).autoconnect()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Group(subviews: content) { collection in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        if let lastItem = collection.last {
                            lastItem
                                .frame(width: size.width, height: size.height)
                                .id(-1)
                        }
                        ForEach(collection.indices, id: \.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                        if let firstItem = collection.first {
                            firstItem
                                .frame(width: size.width, height: size.height)
                                .id(collection.count)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase in
                    isScroll = newPhase.isScrolling
                    
                    if !isScroll && scrollPosition == collection.count && !isHoldingScreen {
                        scrollPosition = 0
                    }
                    if isScroll && scrollPosition == -1 {
                        scrollPosition = collection.count - 1
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isHoldingScreen) { _, out, _ in
                            out = true
                        }
                )
                .onChange(of: isHoldingScreen) { oldValue, newValue in
                    if newValue {
                        timer.upstream.connect().cancel()
                    } else {
                        if isSettled && scrollPosition != offsetBasedPosition {
                            scrollPosition = offsetBasedPosition
                        }
                        timer = Timer.publish(every: Self.autoScrollDuration, on: .main, in: .default).autoconnect()
                    }
                }
                .onReceive(timer) { _ in
                    guard !isHoldingScreen && !isScroll else {
                        return
                    }
                    let nextIndex = (scrollPosition ?? 0) + 1
                    withAnimation(.snappy(duration: 0.25)) {
                        scrollPosition = (nextIndex == collection.count + 1) ? 0 : nextIndex
                    }
                }
                .onChange(of: scrollPosition) { oldValue, newValue in
                    if let newValue {
                        if newValue == -1 {
                            activeIndex = collection.count - 1
                        } else if newValue == collection.count {
                            activeIndex = 0
                        } else {
                            activeIndex = max(min(newValue, collection.count - 1), 0)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { proxy in
                    proxy.contentOffset.x
                } action: { oldValue, newValue in
                    isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
                    let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
                    offsetBasedPosition = index
                    
                    if isSettled && (scrollPosition != index || index == collection.count) && !isScroll && !isHoldingScreen {
                        scrollPosition = index == collection.count ? 0 : index
                    }
                }
                
            }
            .onAppear {
                scrollPosition = 0
            }
        }
        
    }
    
    static var autoScrollDuration: CGFloat {
        return 3.0
    }
}

struct PreviewItem: Identifiable, Hashable {
    let id = UUID()
    let color: Color
}
// 预览示例
#Preview {
    
    
    let items = [
        PreviewItem(color: .red),
        PreviewItem(color: .blue),
        PreviewItem(color: .green)
    ]
    
    ScrollView {
        VStack {
            SDBannerView(data: items) { item in
                item.color
                    //.aspectRatio(1.5, contentMode: .fill)
                    
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .padding(.horizontal, 16)
                
            }
            .frame(height: 200)

        }
        
    }
    //.frame(height: 200)
}
