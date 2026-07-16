import SwiftUI

@main
struct ForgeHubApp: App {
    @StateObject private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        Group {
            switch session.phase {
            case .splash:
                SplashView()
            case .welcome:
                NavigationStack {
                    WelcomeView()
                }
            case .onboarding:
                NavigationStack {
                    OnboardingRoleView()
                }
            case .authenticating:
                NavigationStack {
                    SignInView()
                }
            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: session.phase)
        .sheet(isPresented: $session.showNotifications) {
            NavigationStack { NotificationsCenterView() }
        }
        .sheet(isPresented: $session.showGlobalSearch) {
            NavigationStack { GlobalSearchView() }
        }
        .sheet(isPresented: $session.showUpgradeWall) {
            NavigationStack { UpgradeWallView() }
        }
        .sheet(isPresented: $session.showFeatureSpotlight) {
            NavigationStack { FeatureSpotlightView() }
        }
    }
}
