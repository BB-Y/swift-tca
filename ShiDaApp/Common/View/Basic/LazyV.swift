//
//  LazyV.swift
//  TestHomeView
//
//  Created by 黄祯鑫 on 2025/2/26.
//

import SwiftUI

struct SDLazyVGrid<Data, Content: View>: View where Data: RandomAccessCollection, Data.Element : Identifiable, Data.Index == Int {
    
    typealias Element = Data.Element
    let data: Data
    let columns: Int
    let width: CGFloat
    var hSpacing: CGFloat?
    var vSpacing: CGFloat?
    let hAlignment: Alignment?
    
    
    
    let content: (Element) -> Content

    var grid: [GridItem] {
        var items: [GridItem] = []
        for index in 0..<2*columns - 1 {
            if index%2 == 0 {
                items.append(GridItem(.fixed(width), spacing: 0, alignment: hAlignment))
            } else {
                items.append(GridItem(.flexible(), spacing: 0, alignment: hAlignment))

            }
        }
        return items
    }
    var rows: Int {
        (data.count + columns - 1) / columns
    }
    var counts: Int {
        let totalRows = (data.count + columns - 1) / columns
        return totalRows * (2 * columns - 1)
    }
    init(data: Data, columns: Int, width: CGFloat, hSpacing: CGFloat? = nil, vSpacing: CGFloat? = nil, hAlignment: Alignment? = .center,  @ViewBuilder content: @escaping (Element) -> Content) {
           self.data = data
           self.columns = columns
            self.width = width
           self.content = content
           self.hSpacing = hSpacing
           self.vSpacing = vSpacing
           self.hAlignment = hAlignment

       }
    var body: some View {
        LazyVGrid(columns: grid, spacing: vSpacing) {
            ForEach(0..<counts, id:\.self) { index in
                let row = index / (2 * columns - 1)
                let col = index % (2 * columns - 1)
                
                if col % 2 == 0 {
                    let dataIndex = row * columns + col / 2
                    if dataIndex < data.count {
                        content(data[dataIndex])
                            .frame(maxWidth: .infinity)
                    } else {
                        //Rectangle()
                        Spacer()
                        //Color.clear
                    }
                } else {
                    //Rectangle()

                    Spacer()

                    //Color.clear
                        
                }
            }
        }
        
    }
}

#Preview {
    SDLazyVGrid(data: 0..<10, columns: 3, width: 44, content: {Text(String($0)).frame(width: 50)})
        .padding(.horizontal,30)
}
/*
 struct YXVGridView<Data, Content: View>: View where Data: RandomAccessCollection, Data.Element : Identifiable, Data.Index == Int {
     typealias Element = Data.Element
     let data: Data
     let columns: Int
     var hSpacing: CGFloat?
     var vSpacing: CGFloat?
     let hAlignment: Alignment?
     
     var itemSize: CGFloat?
     
     let content: (Element) -> Content
     
     
     init(data: Data, columns: Int, hSpacing: CGFloat? = nil, vSpacing: CGFloat? = nil, hAlignment: Alignment? = .center,  @ViewBuilder content: @escaping (Element) -> Content) {
         self.data = data
         self.columns = columns
         self.content = content
         self.hSpacing = hSpacing
         self.vSpacing = vSpacing
         self.hAlignment = hAlignment

     }
     init(data: Data, columns: Int, spacing: CGFloat? = nil, hAlignment: Alignment? = .center,  @ViewBuilder content: @escaping (Element) -> Content) {
         self.data = data
         self.columns = columns
         self.content = content
         self.hSpacing = spacing
         self.vSpacing = spacing
         self.hAlignment = hAlignment

     }
     init(data: Data, columns: Int, itemSize: CGFloat, vSpacing: CGFloat? = nil, hAlignment: Alignment? = .center,  @ViewBuilder content: @escaping (Element) -> Content) {
         self.data = data
         self.columns = columns
         self.content = content
         self.hSpacing = 10
         self.vSpacing = vSpacing
         self.hAlignment = hAlignment
         self.itemSize = itemSize
     }
 */
