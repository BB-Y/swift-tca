import SwiftUI

// 定义图书数据协议
protocol SDBookItemProtocol {
    var cover: String? { get }
    var name: String? { get }
    var formattedAuthors: String { get }
    var introduction: String? { get }
    var isbn: String? { get }
}

// 在 SDResponseBookInfo 结构体定义后添加扩展
extension SDResponseBookInfo: SDBookItemProtocol {
    // 协议要求的属性已经在结构体中实现，不需要额外实现
}
// 通用图书项视图组件
struct SDBookItemView<Book: SDBookItemProtocol>: View {
    let book: Book

    
    var body: some View {
        HStack(spacing: 16) {
            // 图书封面
            WebImage(url: book.cover?.url)
                .resizable()
                .scaledToFill()
                .frame(width: 88, height: 130)
                .clipped()
                .border(SDColor.divider)
            
            // 图书信息
            VStack(alignment: .leading, spacing: 8) {
                Text(book.name ?? "未知书名")
                    .font(.sdTitle1)
                    .foregroundStyle(SDColor.text1)
                    .lineLimit(1)
                
                if !book.formattedAuthors.isEmpty {
                    Text(book.formattedAuthors)
                        .font(.sdBody2)
                        .foregroundStyle(SDColor.text2)
                        .lineLimit(1)
                    Spacer()
                }
                
                if let intro = book.introduction {
                    Text(intro)
                        .font(.sdBody3)
                        .foregroundStyle(SDColor.text3)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 箭头
            Image("arrow_right")
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        
    }
}
