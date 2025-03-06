//
//  SDLoginHomeView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI
import ComposableArchitecture

//登录首页
struct SDLoginHomeView: View {
    @Perception.Bindable var store: StoreOf<SDLoginHomeReducer>
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
        } destination: { state in
            switch state.case {
            case .login(let store):
                SDLoginView(store: store)
           
            case .phoneValidate(let store):
                SDValidatePhoneView(store: store)
            }
        }
    }
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            
            if store.loginStatus == .logout {
                SDLoginAgainView(store: .init(initialState: SDLoginAgainReducer.State(), reducer: {
                    SDLoginAgainReducer()
                }))
                
            } else {
                SDLoginView(store: .init(initialState: SDLoginReducer.State(), reducer: { SDLoginReducer() }))
            }
            

            
            Spacer()
                .frame(height: 115)
        }
        .padding()
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    store.send(.onCloseTapped)
                }) {
                    Image("close")
                }
            }
        }
    }
    // 未登录状态的视图
//    @ViewBuilder
//    private var notLoginContent: some View {
//        VStack(spacing: 16) {
//            Button {
//                store.send(.showLogin)
//            } label: {
//                HStack {
//                    Image("icon_login")
//                    Text("登录")
//                }
//            }
//            .buttonStyle(SDButtonStyleConfirm())
//            Button {
//                store.send(.showSignup(.student))
//            } label: {
//                HStack {
//                    Image("icon_signup_student")
//                    Text("学生注册")
//                }
//            }
//            .buttonStyle(SDButtonStyleGray())
//            Button {
//                store.send(.showSignup(.teacher))
//            } label: {
//                HStack {
//                    Image("icon_signup_teacher")
//                    Text("教师注册")
//                }
//            }
//            .buttonStyle(SDButtonStyleGray())
//        }
//        .padding(.horizontal, 40.pad(134))
//    }
    
   
    
   

}

#Preview {
    NavigationStack {
        SDLoginHomeView(store: .init(initialState: .init(), reducer: {
            SDLoginHomeReducer.init()
        }))
    }
}
