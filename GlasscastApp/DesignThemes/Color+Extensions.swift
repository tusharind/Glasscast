import SwiftUI

extension Color {
    // Liquid Glass Palette
    static let glassBackground = Color("GlassBackground")  // Define in Assets if needed, or use code
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let accentStart = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentEnd = Color(red: 0.4, green: 0.8, blue: 1.0)

    static var liquidGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [accentStart, accentEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
