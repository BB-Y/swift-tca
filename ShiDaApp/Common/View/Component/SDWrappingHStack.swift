//
//  SDWappedHStack.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/12.
//

import SwiftUI

struct SDWrappingHStack<Model, V>: View where Model: Hashable, V: View {
    typealias ViewGenerator = (Model) -> V
    
    var models: [Model]
    var viewGenerator: ViewGenerator
    var horizontalSpacing: CGFloat = 2
    var verticalSpacing: CGFloat = 0

    var didFinish: (() -> Void)?
    
    func didFinish(_ action: @escaping () -> Void) -> Self{
        then{$0.didFinish = action}
    }
    @State private var totalHeight
    = CGFloat.zero      // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    init(_ data: [Model], horizontalSpacing: CGFloat = 12, verticalSpacing: CGFloat = 12, @ViewBuilder viewGenerator: @escaping ViewGenerator) {
        self.models = data
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.viewGenerator = viewGenerator
    }
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
        .onChange(of: totalHeight) { willChange in
//            if totalHeight == 0, willChange != 0 {
//                didFinish?()
//            }
            didFinish?()
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.models, id: \.self) { models in
                viewGenerator(models)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > geometry.size.width)
                        {
                            width = 0
                            height -= (dimension.height + verticalSpacing)
                        }
                        let result = width
                        if models == self.models.last! {
                            width = 0 //last item
                        } else {
                            width -= (dimension.width + horizontalSpacing)
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {dimension in
                        let result = height
                        if models == self.models.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

