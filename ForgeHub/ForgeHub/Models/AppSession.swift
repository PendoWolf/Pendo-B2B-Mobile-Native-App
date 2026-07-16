import Foundation
import SwiftUI
import Combine

@MainActor
final class AppSession: ObservableObject {
    enum Phase: Equatable {
        case splash
        case welcome
        case onboarding
        case authenticating
        case main
    }

    @Published var phase: Phase = .splash
    @Published var profile: UserProfile?
    @Published var selectedTab: MainTab = .home
    @Published var showNotifications = false
    @Published var showGlobalSearch = false
    @Published var showUpgradeWall = false
    @Published var showFeatureSpotlight = false
    @Published var isDemoMode = false

    // Onboarding draft
    @Published var draftRole: UserRole = .developer
    @Published var draftCompanySize: CompanySize = .growth
    @Published var draftGoals: Set<AdoptionGoal> = []
    @Published var draftAuthMethod: AuthMethod = .email
    @Published var draftCompanyName: String = ""
    @Published var draftOrgCode: String = ""
    @Published var draftJoinMode: OrgJoinMode = .create

    // Seed data
    @Published var repositories: [Repository] = SampleData.repositories
    @Published var pullRequests: [PullRequest] = SampleData.pullRequests
    @Published var campaigns: [Campaign] = SampleData.campaigns
    @Published var members: [TeamMember] = SampleData.members
    @Published var integrations: [Integration] = SampleData.integrations
    @Published var notifications: [AppNotification] = SampleData.notifications
    @Published var playbooks: [Playbook] = SampleData.playbooks
    @Published var features: [FeatureAdoption] = SampleData.features
    @Published var metrics: [AdoptionMetric] = SampleData.metrics

    var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    func finishSplash() {
        phase = .welcome
    }

    func startGetStarted() {
        isDemoMode = false
        phase = .onboarding
    }

    func startSignIn() {
        isDemoMode = false
        phase = .authenticating
    }

    func startDemo() {
        isDemoMode = true
        profile = .demo
        phase = .main
    }

    func completeOnboarding(name: String, email: String) {
        let initials = name.split(separator: " ").prefix(2).compactMap { $0.first.map(String.init) }.joined()
        profile = UserProfile(
            id: "usr_\(UUID().uuidString.prefix(8))",
            name: name.isEmpty ? "New User" : name,
            email: email.isEmpty ? "user@company.com" : email,
            role: draftRole,
            company: draftCompanyName.isEmpty ? "My Organization" : draftCompanyName,
            companySize: draftCompanySize,
            goals: Array(draftGoals),
            authMethod: draftAuthMethod,
            plan: .free,
            mfaEnabled: false,
            avatarInitials: initials.isEmpty ? "NU" : initials
        )
        phase = .main
    }

    func signIn(as profile: UserProfile = .demo, requireMFA: Bool = false) {
        self.profile = profile
        if requireMFA {
            // Caller navigates to MFA; completion calls finishMFA
            return
        }
        phase = .main
    }

    func finishMFA() {
        if profile == nil { profile = .demo }
        phase = .main
    }

    func signOut() {
        profile = nil
        isDemoMode = false
        selectedTab = .home
        draftGoals = []
        draftCompanyName = ""
        draftOrgCode = ""
        phase = .welcome
    }

    func markAllNotificationsRead() {
        notifications = notifications.map {
            var n = $0
            n.isRead = true
            return n
        }
    }

    func addCampaign(_ campaign: Campaign) {
        campaigns.insert(campaign, at: 0)
    }

    func toggleIntegration(_ id: String) {
        guard let idx = integrations.firstIndex(where: { $0.id == id }) else { return }
        integrations[idx].isConnected.toggle()
    }

    func upgrade(to plan: BillingPlan) {
        guard var p = profile else { return }
        p.plan = plan
        profile = p
    }
}

enum MainTab: String, CaseIterable, Identifiable {
    case home, repositories, adoption, campaigns, more

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .repositories: return "Repos"
        case .adoption: return "Adoption"
        case .campaigns: return "Campaigns"
        case .more: return "More"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .repositories: return "externaldrive.fill.badge.timemachine"
        case .adoption: return "chart.bar.fill"
        case .campaigns: return "megaphone.fill"
        case .more: return "ellipsis.circle.fill"
        }
    }

    var route: AppRoute {
        switch self {
        case .home: return .home
        case .repositories: return .repositories
        case .adoption: return .adoption
        case .campaigns: return .campaigns
        case .more: return .more
        }
    }
}
