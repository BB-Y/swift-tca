import SwiftUI
import ComposableArchitecture
import SkeletonUI

struct SDMessagesView: View {
    @Perception.Bindable var store: StoreOf<SDMessagesFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                SDColor.background
                    .ignoresSafeArea()
                if store.messageList != nil {
                    contentView
                } else if store.hasError {
                    // 显示错误视图
                    SDErrorView(config: .networkError())
                } else if store.messageList?.isEmpty == true {
                    // 显示空消息视图
                    SDErrorView(config: .emptyData())
                }
            }
            .task {
                await store.send(.getMessageList).finish()
            }
            .navigationTitle("消息通知")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("全部已读") {
                        // 这里可以添加全部标记为已读的功能
                    }
                    .font(.sdBody3)
                    .foregroundStyle(SDColor.accent)
                }
            }
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if let messages = store.messageList {
                    ForEach(messages, id: \.id) { message in
                        MessageItemView(message: message)
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

struct MessageItemView: View {
    let message: SDMessageItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 消息标题和状态
            HStack {
                Text(message.title ?? "")
                    .font(.sdBody1)
                    .foregroundStyle(SDColor.text1)
                
                if let status = message.status, status == .unread {
                    Circle()
                        .fill(SDColor.warning)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                Text(message.createTime ?? "")
                    .font(.sdSmall1)
                    .foregroundStyle(SDColor.text3)
            }
            .padding(.top, 16)
            
            // 根据消息类型显示不同样式
            VStack(alignment: .leading, spacing: 8) {
                switch message.type {
                case .discussion:
                    discussionTypeView
                case .correction:
                    correctionTypeView
                case .application:
                    applicationTypeView
                case .locked:
                    lockedTypeView
                case .authentication:
                    authenticationTypeView
                case .none:
                    EmptyView()
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            

            SDLine(SDColor.divider1)
            // 查看详情按钮
            HStack {
                
                
                NavigationLink {
                    // 这里可以导航到消息详情页面
                    Text("消息详情页面")
                } label: {
                    Text("查看详情")
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text1)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(SDColor.text3)
                }
                
            }
            .frame(height: 42)
            
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // 讨论类型消息视图
    @ViewBuilder private var discussionTypeView: some View {
        EmptyView() // 待实现
    }
    
    // 批改类型消息视图
    @ViewBuilder private var correctionTypeView: some View {
        // 消息内容
        Text(message.content ?? "")
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
            .lineLimit(2)
        
        if message.bookName != nil {
            HStack(spacing: 0) {
                Text("相关教材：")
                Text("《\(message.bookName ?? "")》")
            }
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
        }
        
        if message.chapterName != nil && !message.chapterName!.isEmpty {
            HStack(spacing: 0) {
                Text("所在章节：")
                Text(message.chapterName ?? "")
            }
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
        }
        
        if message.replyRemark != nil && !message.replyRemark!.isEmpty {
            HStack(spacing: 0) {
                Text("回复内容：")
                Text(message.replyRemark ?? "")
            }
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
        }
        
    }
    
    // 申请类型消息视图
    @ViewBuilder private var applicationTypeView: some View {
        Text(message.content ?? "")
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
            .lineLimit(2)
        if message.bookName != nil {
            HStack(spacing: 0) {
                Text("相关教材：")
                Text("《\(message.bookName ?? "")》")
            }
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
        }
        
    }
    
    // 锁定类型消息视图
    @ViewBuilder private var lockedTypeView: some View {
        EmptyView() // 待实现
    }
    
    // 认证类型消息视图
    @ViewBuilder private var authenticationTypeView: some View {
        Text(message.content ?? "")
            .font(.sdBody3)
            .foregroundStyle(SDColor.text2)
            .lineLimit(2)
    }
}

#Preview {
    NavigationStack {
        SDMessagesView(
            store: Store(
                initialState: SDMessagesFeature.State(),
                reducer: {
                    SDMessagesFeature()
                        ._printChanges()
                        .dependency(\.userClient, .previewValue)
                }
            )
        )
    }
}
