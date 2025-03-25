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
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                WithPerceptionTracking {
                    content
                        //.frame(maxHeight: .infinity)
                        .ignoresSafeArea(.keyboard, edges:  .bottom)

                        

                }
                
            } destination: { state in
                WithPerceptionTracking {
                    switch state.case {
        //            case .login(let store):
        //                SDLoginView(store: store)
                    case .codeValidate(let store):
                        SDValidateCodeView(store: store)
                    case .phoneValidate(let store):
                        SDValidatePhoneView(store: store)
        //            case .loginAgain(let store):
        //                SDLoginAgainView(store: store)
                    case .selectUserType(let store):
                        SDSelectUserTypeView(store: store)
                    case .resetPassword(let store):
                        SDSetNewPasswordView(store: store)
                    }
                }
                .toolbarRole(.editor)
                
            }
            .sdTint(SDColor.accent)
            .ignoresSafeArea(.keyboard, edges:  .bottom)
        }
        

    }
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            
            if store.showlogin  {
                
                SDLoginView(store: store.scope(state: \.login, action: \.login))
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            } else {
                SDLoginAgainView(store: store.scope(state: \.loginAgain, action: \.loginAgain))
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
            }
        }
        
        .navigationTitle("")
        .animation(.easeInOut, value: store.showlogin)
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
 
    
   

}

#Preview {
    NavigationStack {
        SDLoginHomeView(store: .init(initialState: .init(), reducer: {
            SDLoginHomeReducer.init()
                ._printChanges()
        }))
    }
}
