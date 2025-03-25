//
//  SDButtonStyle.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/5.
//

import SwiftUI
extension ButtonStyle where Self == SDButtonStyleConfirm<Capsule> {

    static func sdConfirm(isDisable: Bool = false) -> Self {
        SDButtonStyleConfirm(
            isDisable: isDisable,
            background: SDColor.accent,
            foreground: .white,
            height: 46,
            font: .sdBody1.weight(.medium),
            shape: Capsule()
        )
    }
    static func sdConfirmRed(isDisable: Bool = false) -> Self {
        SDButtonStyleConfirm(
            isDisable: isDisable,
            background: SDColor.warning,
            foreground: .white,
            height: 46,
            font: .sdBody1.weight(.medium),
            shape: Capsule()
        )
    }
    
    static func sdMiddle(
          isDisable: Bool = false,
          background: Color = SDColor.accent,
          foreground: Color = .white
      ) -> Self {
          SDButtonStyleConfirm(
              isDisable: isDisable,
              background: background,
              foreground: foreground,
              height: 42,
              font: .sdBody1.weight(.medium),
              shape: Capsule())
      }
    static func sdSmall(
          isDisable: Bool = false,
          height: CGFloat = 36
      ) -> Self {
          SDButtonStyleConfirm(
              isDisable: isDisable,
              background: SDColor.accent,
              foreground: .white,
              height: 36,
              font: .sdBody3.weight(.medium),
              shape: Capsule())
      }
    
    static func sdSmall1(
          isDisable: Bool = false
      ) -> Self {
          SDButtonStyleConfirm(
              isDisable: isDisable,
              background: SDColor.accent,
              foreground: .white,
              height: 26,
              font: .sdBody4.weight(.medium),
              shape: Capsule())
      }
    
//    static func sdCustom(isDisable: Bool = false,color: Color = SDColor.accent) -> Self {
//        Self(isDisable: isDisable, color: color, buttonType: .custom)
//    }
}
struct SDButtonStyleConfirm<S: Shape>: ButtonStyle {
    enum ButtonType {
        case confirm
        
        case middle
        case small
        
        case custom

        
    }
    let isDisable: Bool
    let background: Color
    let foreground: Color
    let height: CGFloat?
    let font: Font?
    let shape: S
    
    init(isDisable: Bool = false, background: Color = SDColor.accent,foreground: Color = .white, height: CGFloat? = 46, font: Font? = nil, shape: S = Capsule()) {
        self.isDisable = isDisable
        self.background = background
        self.foreground = foreground
        self.font = font
        self.height = height
        self.shape = shape

    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: height)
            .font(font)
            .frame(maxWidth: .infinity)
            .background(isDisable ? background.opacity(0.5) : background)
            .foregroundStyle(foreground)
            .clipShape(shape)
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
