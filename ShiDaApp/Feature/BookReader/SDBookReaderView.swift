//
//  SDBookReaderView.swift
//  ShiDaApp
//
//  Created by 叶建锋 on 2025/3/20.
//

import SwiftUI


@ViewAction(for: SDBookReaderReducer.self)
struct SDBookReaderView: View {
    @Perception.Bindable var store: StoreOf<SDBookReaderReducer>
    var storePage = Store(
        initialState: BookPageReducer.State(nextPage: 0, prePage: 0),
        reducer: { BookPageReducer() }
        )
    @State var progress: CGFloat = 1
    var safeAreaHeight: CGFloat {
        UIApplication.statusBarAndNavigationBarHeight
    }
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            content
            if storePage.state.showMenu
            {
                bar
            }
            if let errorMessage = store.errorMessage {
                SDErrorView(config: .networkError())
                
            }
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            send(.onAppear)
        }
        .sdLoadingToast(isPresented: $store.isLoading)
        
    }
    
    @ViewBuilder var content: some View {
        BookPageView(store: store, storePage: storePage)
    }
    
    var bar: some View {
        HStack {
            Button {
                send(.onBackTapped)
            } label: {
                Image("back")
            }
            Spacer()
            if let bookDetail = store.bookDetail {
                Text(bookDetail.name)
                    .font(.sdTitle)
                    .foregroundStyle(SDColor.text1)
                    .opacity(progress)
            }
            
            Spacer()
            
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(progress))
    }
}

#Preview {
//    NavigationStack {
//        SDBookReaderView(
//            store: Store(
//                initialState: SDBookReaderReducer.State(id: 121, catalogId: 15404),
//                reducer: {
//                    SDBookReaderReducer()
//                        .dependency(\.bookReaderClient, .liveValue)
//                    
//                }
//            )
//        )
//    }
}
