import SwiftUI

struct RouteMarker: ViewModifier {
    let route: AppRoute

    func body(content: Content) -> some View {
        content
            .accessibilityIdentifier("route.\(route.rawValue)")
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 0) {
                        Text(navigationTitle)
                            .font(.headline)
                        Text(route.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
    }

    private var navigationTitle: String {
        AppRouteCatalog.description(for: route)
            .components(separatedBy: ":")
            .first?
            .trimmingCharacters(in: .whitespaces) ?? route.rawValue
    }
}

extension View {
    func tracked(route: AppRoute) -> some View {
        modifier(RouteMarker(route: route))
    }

    /// Lightweight marker for screens that already set their own title.
    func routeID(_ route: AppRoute) -> some View {
        accessibilityIdentifier("route.\(route.rawValue)")
            .background(
                Text(route.rawValue)
                    .font(.system(size: 1))
                    .foregroundStyle(.clear)
                    .accessibilityHidden(true)
            )
    }
}

struct ScreenHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.largeTitle.bold())
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MetricCard: View {
    let metric: AdoptionMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(metric.value)
                .font(.title.bold())
            Text(metric.delta)
                .font(.caption.weight(.semibold))
                .foregroundStyle(metric.isPositive ? AppTheme.success : AppTheme.danger)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct StatusChip: View {
    let text: String
    var color: Color = AppTheme.brand

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let cta: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.brand)
            Text(title)
                .font(.title2.bold())
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(cta, action: action)
                .buttonStyle(PrimaryButtonStyle())
                .frame(maxWidth: 260)
        }
        .padding(24)
    }
}

struct ProgressDots: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? AppTheme.brand : Color.gray.opacity(0.25))
                    .frame(width: index == current ? 22 : 8, height: 8)
            }
        }
    }
}

struct ListRowCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
