import SwiftUI

struct Theme {
    enum AppColor {
        case primaryText
        case secondaryText
        case background
        case surface
        case surfaceSecondary
        case accentPrimary
        case accentSecondary
        case error
        case caution
        case tintOrb
        case glassBase

        var color: Color {
            switch self {
            case .primaryText: return .white
            case .secondaryText: return .white.opacity(0.7)
            case .background: return .black
            case .surface: return .white.opacity(0.15)
            case .surfaceSecondary: return .black.opacity(0.2)
            case .accentPrimary: return Color(red: 0.2, green: 0.6, blue: 1.0)
            case .accentSecondary: return Color(red: 0.4, green: 0.8, blue: 1.0)
            case .error: return .red
            case .caution: return .yellow
            case .tintOrb: return .purple
            case .glassBase: return Color("GlassBackground")
            }
        }
    }

    enum AppGradient {
        case liquid
        case glassBorder
        case glassShimmer

        var gradient: LinearGradient {
            switch self {
            case .liquid:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        AppColor.accentPrimary.color,
                        AppColor.accentSecondary.color,
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .glassBorder:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        AppColor.primaryText.color.opacity(0.4),
                        AppColor.primaryText.color.opacity(0.1),
                        AppColor.primaryText.color.opacity(0.05),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .glassShimmer:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        AppColor.primaryText.color.opacity(0.15),
                        AppColor.primaryText.color.opacity(0.05),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

// Convenience extension
extension Color {
    static func theme(_ appColor: Theme.AppColor) -> Color {
        appColor.color
    }
}

extension LinearGradient {
    static func theme(_ appGradient: Theme.AppGradient) -> LinearGradient {
        appGradient.gradient
    }
}
