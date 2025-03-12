import SwiftUI
import ComposableArchitecture

struct SDSearchOverlay: View {
    @Perception.Bindable var store: StoreOf<SDSearchOverlayFeature>
    
    func itemsView(_ data: [String], isHot: Bool) -> some View {
        SDWrappingHStack(Array(0..<data.count)) { index in
            Button {
                store.send(.onSelectItem(data[index]))
            } label: {
                HStack(spacing: 4) {
                    if isHot {
                        Text("\(index + 1) ")
                            .foregroundColor(.red)
                        +
                        Text(data[index])
                            .foregroundColor(.black)
                    } else {
                        Text(data[index])
                            .foregroundColor(.black)
                    }
                }
                .lineLimit(1)
                .font(.sdBody3)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(SDColor.inputBackground)
                .clipShape(Capsule())
            }
        }
    }
    
    func sectionView(_ data: [String], isHot: Bool) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(isHot ? "热门搜索" : "搜索历史")
                   
                Spacer()
                if !isHot {
                    Button {
                        store.send(.clearSearchHistory)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                    }
                }
            }
                .font(.sdTitle1)
                .foregroundStyle(SDColor.text1)
            itemsView(data, isHot: isHot)
        }
    }
    
    var body: some View {
        // 搜索内容
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 热门搜索
                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    sectionView(store.hotSearches, isHot: true)
                    
                    // 搜索历史
                    if !store.searchHistory.isEmpty {
                        sectionView(store.searchHistory, isHot: false)
                    }
                }
            }
            .padding(16)
        }
        .background {
            Color.white.ignoresSafeArea()
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    SDSearchOverlay(
        store: Store(initialState: SDSearchOverlayFeature.State()) {
            SDSearchOverlayFeature()
                .dependency(\.searchClient, .liveValue)
                ._printChanges()
        }
    )
}
