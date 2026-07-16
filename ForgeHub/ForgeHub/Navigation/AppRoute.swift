import Foundation

/// Canonical route identifiers for analytics / path-scanning tooling.
enum AppRoute: String, CaseIterable, Hashable {
    // Entry
    case splash
    case welcome
    case demoMode

    // Onboarding
    case onboardingRole
    case onboardingCompany
    case onboardingGoals
    case onboardingAuthChoice
    case onboardingOrgChoice
    case onboardingCreateOrg
    case onboardingJoinOrg
    case onboardingInviteTeam
    case onboardingFirstRepo
    case onboardingComplete

    // Auth
    case authSignIn
    case authEmailSignUp
    case authSSO
    case authOAuth
    case authMagicLink
    case authMagicLinkSent
    case authMFA
    case authForgotPassword
    case authResetSent

    // Tabs
    case home
    case repositories
    case adoption
    case campaigns
    case more

    // Home branches
    case homeQuickStart
    case homeFeatureSpotlight
    case homeActivityDetail

    // Repositories
    case repoList
    case repoSearch
    case repoFilters
    case repoDetail
    case repoCreate
    case repoCreateSuccess
    case repoImport
    case repoBranches
    case repoFiles
    case repoCommits
    case repoSettings
    case repoEmptyState

    // Pull requests
    case prList
    case prDetail
    case prReview
    case prChecks
    case prMerge
    case prCreate

    // Adoption
    case adoptionOverview
    case adoptionFeatures
    case adoptionFeatureDetail
    case adoptionSegments
    case adoptionSegmentDetail
    case adoptionPlaybooks
    case adoptionPlaybookDetail
    case adoptionPlaybookActivate
    case adoptionNudges

    // Campaigns
    case campaignList
    case campaignCreateGoal
    case campaignCreateAudience
    case campaignCreateChannel
    case campaignCreateContent
    case campaignCreateSchedule
    case campaignCreateReview
    case campaignDetail
    case campaignAnalytics
    case campaignABTest
    case campaignEmptyState

    // Team
    case teamMembers
    case teamInvite
    case teamInviteSent
    case teamRoles
    case teamCreate
    case teamDetail

    // Billing
    case billingPlans
    case billingUpgrade
    case billingCheckout
    case billingSuccess
    case billingInvoices

    // Integrations
    case integrationsList
    case integrationDetail
    case integrationConnect
    case integrationConfigure
    case integrationSuccess

    // Settings
    case settingsRoot
    case settingsProfile
    case settingsProfileEdit
    case settingsNotifications
    case settingsSecurity
    case settingsMFASetup
    case settingsAppearance
    case settingsHelp
    case settingsFAQ
    case settingsContact
    case settingsFeedback
    case settingsAbout

    // Global overlays
    case notificationsCenter
    case globalSearch
    case upgradeWall
}

enum AppRouteCatalog {
    static let allRoutes: [AppRoute] = AppRoute.allCases

    static var routeCount: Int { allRoutes.count }

    static func description(for route: AppRoute) -> String {
        switch route {
        case .splash: return "Cold start splash"
        case .welcome: return "Entry choice: sign in / get started / demo"
        case .demoMode: return "Explore product without account"
        case .onboardingRole: return "Select persona / role"
        case .onboardingCompany: return "Company size"
        case .onboardingGoals: return "Adoption goals multi-select"
        case .onboardingAuthChoice: return "Pick auth method"
        case .onboardingOrgChoice: return "Create or join organization"
        case .onboardingCreateOrg: return "Create org form"
        case .onboardingJoinOrg: return "Join with invite code"
        case .onboardingInviteTeam: return "Invite teammates (skippable)"
        case .onboardingFirstRepo: return "Create or skip first repository"
        case .onboardingComplete: return "Onboarding success"
        case .authSignIn: return "Email / password sign in"
        case .authEmailSignUp: return "Email sign up"
        case .authSSO: return "Enterprise SSO"
        case .authOAuth: return "OAuth provider picker"
        case .authMagicLink: return "Magic link request"
        case .authMagicLinkSent: return "Magic link confirmation"
        case .authMFA: return "Multi-factor challenge"
        case .authForgotPassword: return "Forgot password"
        case .authResetSent: return "Password reset sent"
        case .home: return "Home dashboard tab"
        case .repositories: return "Repositories tab"
        case .adoption: return "Adoption hub tab"
        case .campaigns: return "Campaigns tab"
        case .more: return "More / settings tab"
        case .homeQuickStart: return "Quick-start checklist"
        case .homeFeatureSpotlight: return "Feature spotlight sheet"
        case .homeActivityDetail: return "Activity item detail"
        case .repoList: return "Repository list"
        case .repoSearch: return "Repository search"
        case .repoFilters: return "Repository filters"
        case .repoDetail: return "Repository detail"
        case .repoCreate: return "Create repository wizard"
        case .repoCreateSuccess: return "Repo created success"
        case .repoImport: return "Import repository"
        case .repoBranches: return "Branches list"
        case .repoFiles: return "File browser"
        case .repoCommits: return "Commit history"
        case .repoSettings: return "Repository settings"
        case .repoEmptyState: return "Empty repos CTA"
        case .prList: return "Pull request list"
        case .prDetail: return "Pull request detail"
        case .prReview: return "Submit review"
        case .prChecks: return "CI checks"
        case .prMerge: return "Merge confirmation"
        case .prCreate: return "Create pull request"
        case .adoptionOverview: return "Adoption metrics overview"
        case .adoptionFeatures: return "Feature adoption list"
        case .adoptionFeatureDetail: return "Single feature adoption"
        case .adoptionSegments: return "User segments"
        case .adoptionSegmentDetail: return "Segment detail"
        case .adoptionPlaybooks: return "Playbook catalog"
        case .adoptionPlaybookDetail: return "Playbook detail"
        case .adoptionPlaybookActivate: return "Activate playbook"
        case .adoptionNudges: return "Recommended nudges"
        case .campaignList: return "Campaign list"
        case .campaignCreateGoal: return "Campaign wizard: goal"
        case .campaignCreateAudience: return "Campaign wizard: audience"
        case .campaignCreateChannel: return "Campaign wizard: channel"
        case .campaignCreateContent: return "Campaign wizard: content"
        case .campaignCreateSchedule: return "Campaign wizard: schedule"
        case .campaignCreateReview: return "Campaign wizard: review"
        case .campaignDetail: return "Campaign detail"
        case .campaignAnalytics: return "Campaign analytics"
        case .campaignABTest: return "A/B test variants"
        case .campaignEmptyState: return "No campaigns CTA"
        case .teamMembers: return "Team members"
        case .teamInvite: return "Invite member form"
        case .teamInviteSent: return "Invite sent confirmation"
        case .teamRoles: return "Role permissions"
        case .teamCreate: return "Create team"
        case .teamDetail: return "Team detail"
        case .billingPlans: return "Plan comparison"
        case .billingUpgrade: return "Upgrade selection"
        case .billingCheckout: return "Checkout"
        case .billingSuccess: return "Upgrade success"
        case .billingInvoices: return "Invoice history"
        case .integrationsList: return "Integrations catalog"
        case .integrationDetail: return "Integration detail"
        case .integrationConnect: return "Connect integration"
        case .integrationConfigure: return "Configure integration"
        case .integrationSuccess: return "Integration connected"
        case .settingsRoot: return "Settings root"
        case .settingsProfile: return "Profile view"
        case .settingsProfileEdit: return "Edit profile"
        case .settingsNotifications: return "Notification prefs"
        case .settingsSecurity: return "Security settings"
        case .settingsMFASetup: return "MFA enrollment"
        case .settingsAppearance: return "Appearance"
        case .settingsHelp: return "Help center"
        case .settingsFAQ: return "FAQ"
        case .settingsContact: return "Contact support"
        case .settingsFeedback: return "Product feedback"
        case .settingsAbout: return "About ForgeHub"
        case .notificationsCenter: return "Notifications center"
        case .globalSearch: return "Global search"
        case .upgradeWall: return "Paywall / upgrade wall"
        }
    }
}
