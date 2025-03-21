import SwiftUI

struct SDHelpFeedbackView: View {
    @Environment(\.dismiss) var dismiss
    @State var showToast = false
    var body: some View {
        VStack(spacing: 16) {
            // 顶部标题栏
            HStack {
                Text("帮助反馈")
                    .font(.sdBody1)
                    .foregroundStyle(SDColor.text1)
            }
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Button {
                    dismiss()

                } label: {
                    Image("close")
                        .resizable()
                        .frame(width:16, height: 16)
                }
                .frame(width:32, height: 32)
                .padding(.trailing, 16)

            }
            
       
            
            // 反馈选项列表
            VStack(spacing: 10) {
                feedbackItem(title: "客服电话", detail: "010-13656841")
                
                
                
                feedbackItem(title: "客服工作时间", detail: "09:00-12:00\n13:30-17:00")
                
              
                
                feedbackItem(title: "邮箱", detail: "459435658@163.com")
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            
            Spacer()
            
        }
        .background(Color.white)
        .sdToast(isPresented: $showToast, config: .init(message: "已复制到剪贴板"))
    }
    
    private func feedbackItem(title: String, detail: String) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.sdBody1)
                    .foregroundStyle(SDColor.text1)
                
                if title == "客服电话" {
                    Link(detail, destination: URL(string: "tel:\(detail.replacingOccurrences(of: "-", with: ""))")!)
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text2)
                } else if title == "邮箱" {
                    Text(detail)
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text2)
                        .onTapGesture {
                            UIPasteboard.general.string = detail
                            if showToast == false {
                                showToast = true
                            }
                        }
                } else {
                    Text(detail)
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text2)
                }
            }
            
            Spacer()
        }
        
    }
}

#Preview {
    ZStack {
        Color.gray
        SDHelpFeedbackView()

    }
}
