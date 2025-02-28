//
//  SDPhoneInputView.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDPhoneInputView: View {
    let placeHolder: String
    @Binding var phone: String
    @Binding var nationCode: String
    @State var showNationList = false
    init(_ placeHolder: String, phone: Binding<String>, nationCode: Binding<String>, showNationList: Bool = false) {
        self.placeHolder = placeHolder
        self._phone = phone
        self._nationCode = nationCode
        self.showNationList = showNationList
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                showNationList = true
            } label: {
                HStack(spacing: 4) {
                    Text("+\(nationCode)")
                    Image("arrow_down")
                }
                .foregroundStyle(SDColor.text1)
            }

            
            
            SDLine(SDColor.text3, axial: .vertical)
                .frame(height: 14)
            TextField(placeHolder,text: $phone)
                .modifier(SDTextFieldWithClearButtonModefier(text: $phone))
        }
        .font(.sdBody1)
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background {
            SDColor.background
                .clipShape(Capsule())
        }
        .sheet(isPresented: $showNationList) {
            ScrollView {
                ForEach(0..<50) { item in
                    Text("\(item)")
                        .onTapGesture {
                            nationCode = "\(item)"
                            showNationList.toggle()
                        }
                }
                
            }
            .sdSheetBackground({
                Color.red
            })
            .presentationDetents([.medium, .large, .fraction(0.8), .height(200)])

        }
    }
}

#Preview {
    SDPhoneInputView("请输入手机号", phone: .constant("3232"), nationCode: .constant("86"))
}
