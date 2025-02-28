//
//  SDSecureField.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/3.
//

import SwiftUI

struct SDSecureField: View {
    let placeHolder: String
    @Binding var text: String
    @State var showTextWhenSecure: Bool = false
    let isSecure: Bool
    init(_ placeHolder: String, text: Binding<String>, isSecure: Bool) {
        self.placeHolder = placeHolder
        
        self._text = text
        self.isSecure = isSecure
    }
    
    private var shuoldShowTextField: Bool {
        if isSecure && !showTextWhenSecure{
            return false
        }
       
        return true
    }
    var body: some View {
        HStack {
            ZStack {
                TextField(placeHolder, text: $text)
                      .opacity(shuoldShowTextField ? 1 : 0)

                if isSecure {
                    SecureField(placeHolder, text: $text)
                           .opacity(showTextWhenSecure ? 0 : 1)
                }
                
            }
            
            .modifier(SDTextFieldWithClearButtonModefier(text: $text))
            
            if isSecure {
                Image(showTextWhenSecure ? "eye_open" : "eye_close")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showTextWhenSecure.toggle()
                    }
            }
            
        }
        .frame(height: 50)
       
        
    }
}

#Preview {
    SDSecureField("请输入", text: .constant("31321"),  isSecure: false)
}


struct ContentView: View {
  @State private var isAnimating = false

  var body: some View {
    VStack {
      Text("Hello, SwiftUI!")
        .opacity(isAnimating ? 0 : 1)
        .font(.largeTitle)
        .padding()
        //.animation(.easeInOut(duration: 2).repeatCount(2), value: isAnimating)
        Button(isAnimating ? "Fade In" : "Fade Out") {
            withAnimation(.easeInOut(duration: 2).repeatCount(2, autoreverses: true)) {
                isAnimating.toggle()

            }
            
        }
      }
    }
  
}
#Preview {
    ContentView()
}
