import SwiftUI

struct SDCapsuleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(SDColor.error)
            .clipShape(Capsule())
           
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(SDColor.text1)
    }
}

extension TextFieldStyle where Self == SDCapsuleTextFieldStyle {
    static var sdCapsule: SDCapsuleTextFieldStyle { SDCapsuleTextFieldStyle() }
}
