import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.brandDark.opacity(0.12), AppTheme.surface],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                Spacer()

                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(AppTheme.brand)

                ScreenHeader(
                    title: "ForgeHub",
                    subtitle: "Enterprise code collaboration with built-in adoption marketing — so teams actually use what you ship."
                )

                VStack(spacing: 12) {
                    Button("Get started") { session.startGetStarted() }
                        .buttonStyle(PrimaryButtonStyle())
                        .accessibilityIdentifier("cta.getStarted")

                    Button("Sign in") { session.startSignIn() }
                        .buttonStyle(SecondaryButtonStyle())
                        .accessibilityIdentifier("cta.signIn")

                    Button("Explore demo workspace") { session.startDemo() }
                        .buttonStyle(GhostButtonStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                        .accessibilityIdentifier("cta.demo")
                }

                NavigationLink("See all scannable routes") {
                    RouteCatalogView()
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.accent)

                Spacer()
            }
            .padding(24)
        }
        .routeID(.welcome)
        .navigationBarHidden(true)
    }
}

struct RouteCatalogView: View {
    var body: some View {
        List {
            Section("\(AppRouteCatalog.routeCount) routes") {
                ForEach(AppRouteCatalog.allRoutes, id: \.self) { route in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(route.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.brand)
                        Text(AppRouteCatalog.description(for: route))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                    .accessibilityIdentifier("routeCatalog.\(route.rawValue)")
                }
            }
        }
        .navigationTitle("Route Catalog")
        .routeID(.demoMode)
    }
}
