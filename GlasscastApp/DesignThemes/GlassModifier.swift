import SwiftUI

struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    var opacity: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // The blur effect
                    VisualEffectView(
                        effect: UIBlurEffect(
                            style: .systemUltraThinMaterialDark
                        )
                    )
                    .opacity(opacity)

                    // Subtle gradient overlay for "liquid" feel
                    LinearGradient.theme(.glassShimmer)
                }
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient.theme(.glassBorder),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.theme(.background).opacity(0.2),
                radius: 10,
                x: 0,
                y: 10
            )
    }
}

// Helper for UIVisualEffectView in SwiftUI
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>)
        -> UIVisualEffectView
    {
        UIVisualEffectView()
    }

    func updateUIView(
        _ uiView: UIVisualEffectView,
        context: UIViewRepresentableContext<Self>
    ) {
        uiView.effect = effect
    }
}

extension View {
    func glassEffect(cornerRadius: CGFloat = 20, opacity: CGFloat = 0.8)
        -> some View
    {
        self.modifier(
            GlassModifier(cornerRadius: cornerRadius, opacity: opacity)
        )
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
