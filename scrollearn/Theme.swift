import SwiftUI

// MARK: - Colors
struct ThemeColors {
    static let background = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.12, green: 0.12, blue: 0.12),
            Color(red: 0.08, green: 0.08, blue: 0.08)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.10)
    static let menuBackground = Color(red: 0.13, green: 0.13, blue: 0.13)
}

// MARK: - Typography
struct ThemeTypography {
    static let title = Font.system(size: 48, weight: .bold, design: .default)
    static let subtitle = Font.system(size: 22, weight: .regular, design: .default)
    static let caption = Font.caption
    static let sectionTitle = Font.system(size: 16, weight: .semibold, design: .default)
    static let indexCounter = Font.system(size: 14, weight: .medium, design: .monospaced)
    static let menuItem = Font.system(size: 13, weight: .medium, design: .default)
}

// MARK: - Spacing
struct ThemeSpacing {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xlarge: CGFloat = 32
}
