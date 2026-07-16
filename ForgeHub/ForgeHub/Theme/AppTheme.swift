import SwiftUI

enum AppTheme {
    static let brand = Color(red: 0.12, green: 0.42, blue: 0.78)
    static let brandDark = Color(red: 0.06, green: 0.22, blue: 0.45)
    static let accent = Color(red: 0.00, green: 0.62, blue: 0.58)
    static let warning = Color(red: 0.90, green: 0.55, blue: 0.10)
    static let danger = Color(red: 0.82, green: 0.22, blue: 0.25)
    static let success = Color(red: 0.18, green: 0.68, blue: 0.38)
    static let surface = Color(.systemBackground)
    static let surfaceSecondary = Color(.secondarySystemBackground)
    static let muted = Color(.secondaryLabel)

    static let heroGradient = LinearGradient(
        colors: [brandDark, brand, accent.opacity(0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isEnabled ? AppTheme.brand : Color.gray.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(AppTheme.brand)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.brand.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.muted)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
