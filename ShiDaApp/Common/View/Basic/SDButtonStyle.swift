//
//  SDButtonStyle.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDButtonStyleConfirm: ButtonStyle {
    
    let isDisable: Bool
    let color: Color
    init(isDisable: Bool = false, color: Color = SDColor.accent) {
        self.isDisable = isDisable
        self.color = color
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sdBody1)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(isDisable ? color.opacity(0.5) : color)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
struct SDButtonStyleGray: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sdBody1)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(SDColor.buttonBackGray)
            .foregroundStyle(SDColor.text2)
            .clipShape(Capsule())
    }
}
struct SDButtonStyleDisabled: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? SDColor.accent : SDColor.accent.opacity(0.5))

    }
}


//extension PrimitiveButtonStyle where Self == SDDisabledButtonStyle {
//    @MainActor @preconcurrency internal static var sdDisabled: SDDisabledButtonStyle {
//        SDDisabledButtonStyle()
//    }
//}
