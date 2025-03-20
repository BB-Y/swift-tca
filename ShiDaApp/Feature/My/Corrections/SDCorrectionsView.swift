import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDCorrectionsView: View {
    @Perception.Bindable var store: StoreOf<SDCorrectionsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                SDColor.background
                    .ignoresSafeArea()
                if store.correctionList != nil {
                    contentView
                } else if store.hasError {
                    // 显示错误视图
                    SDErrorView(config: .networkError())
                } else if store.correctionList?.isEmpty == true {
                    // 显示空纠错视图
                    SDErrorView(config: .emptyData())
                }
            }
            .task {
                await store.send(.getCorrectionList).finish()
            }
            .navigationTitle("我的纠错")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if let corrections = store.correctionList {
                    ForEach(corrections) { correction in
                        CorrectionItemView(correction: correction)
                        
                    }
                    
                    if store.canLoadMore {
                        ProgressView()
                            .frame(height: 50)
                            .onAppear {
                                store.send(.loadMore)
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .refreshable {
            await store.send(.onAppear).finish()
        }
    }
}

struct CorrectionItemView: View {
    let correction: SDResponseCorrectionInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 纠错类型
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("内容纠错")
                        .font(.sdBody1)
                        .foregroundStyle(SDColor.text1)
                    Spacer()
                    Text(correction.replyStatus == .processed ? "已处理" : "待处理")
                        .font(.sdSmall1)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 8)
                        .frame(height: 20)
                        .background {
                            correction.replyStatus == .processed ? SDColor.accent : SDColor.text3
                        }
                        .cornerRadius(2)

                }
                // 教材信息
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("纠错教材：")
                        Text("《\(correction.dbookName ?? "")》")

                    }
                    HStack(alignment: .top, spacing: 0) {
                        
                        Text("所在章节：")
                        Text("\(correction.chapterName ?? "")")
                    }
                    HStack(alignment: .top, spacing: 0) {
                        
                        Text("纠错反馈：")
                        Text("\(correction.content ?? "")")
                    }
                    HStack(alignment: .top, spacing: 0) {
                        
                        Text("纠错原文：")
                        Text("\(correction.text ?? "")")
                    }
                 
                       
                }
                .font(.sdBody3)
                .foregroundStyle(SDColor.text2)
            }
            .padding(.vertical, 16)

            SDLine(SDColor.divider)
           
            
            // 时间和状态
            HStack {
                Text(correction.createDatetime ?? "")  // 这里应该使用实际的时间字段
                    .font(.sdSmall1)
                    .foregroundStyle(SDColor.text3)
                
                Spacer()

            }
            .frame(height: 40)
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        SDCorrectionsView(
            store: Store(
                initialState: SDCorrectionsFeature.State(),
                reducer: {
                    SDCorrectionsFeature()
                        ._printChanges()
                        .dependency(\.myClient, .previewValue)
                }
            )
        )
    }
}
