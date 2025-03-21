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
    
    @State var progress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            SDColor.background.ignoresSafeArea()
            content
            bar
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            send(.onAppear)
        }
        .sdLoadingToast(isPresented: $store.isLoading)
        
    }
    
    @ViewBuilder var content: some View {
        GsdWebView(htmlString: store.state.getChapterContent(),
                   baseURL: Bundle.main.resourceURL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            Button {
                //send(.favoriteButtonTapped)
            } label: {
                Image("star")
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(Color(hex: "#E7F1EE").opacity(progress))
    }
}

#Preview {
    NavigationStack {
        SDBookReaderView(
            store: Store(
                initialState: SDBookReaderReducer.State(id: 121, chapterId: 15404),
                reducer: {
                    SDBookReaderReducer()
                        .dependency(\.bookReaderClient, .liveValue)
                    
                }
            )
        )
    }
}
