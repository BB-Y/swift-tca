//
//  SDButtonStyle.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI

struct SDButtonStyleConfirm: ButtonStyle {
    
    let isDisable: Bool
    init(isDisable: Bool = false) {
        self.isDisable = isDisable
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sdBody1)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(isDisable ? SDColor.accent.opacity(0.5) : SDColor.accent)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
struct SDButtonStyleGray: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sdBody1)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(SDColor.buttonBackGray)
            .foregroundStyle(SDColor.text1)
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
