import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        TabView(selection: $session.selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label(MainTab.home.title, systemImage: MainTab.home.icon) }
                .tag(MainTab.home)

            NavigationStack { RepositoryListView() }
                .tabItem { Label(MainTab.repositories.title, systemImage: MainTab.repositories.icon) }
                .tag(MainTab.repositories)

            NavigationStack { AdoptionOverviewView() }
                .tabItem { Label(MainTab.adoption.title, systemImage: MainTab.adoption.icon) }
                .tag(MainTab.adoption)

            NavigationStack { CampaignListView() }
                .tabItem { Label(MainTab.campaigns.title, systemImage: MainTab.campaigns.icon) }
                .tag(MainTab.campaigns)

            NavigationStack { MoreRootView() }
                .tabItem { Label(MainTab.more.title, systemImage: MainTab.more.icon) }
                .tag(MainTab.more)
                .badge(session.unreadCount)
        }
        .tint(AppTheme.brand)
    }
}
