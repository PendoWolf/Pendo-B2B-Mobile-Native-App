import Foundation

enum UserRole: String, CaseIterable, Identifiable, Codable {
    case engineeringManager = "Engineering Manager"
    case developer = "Developer"
    case devops = "DevOps / Platform"
    case product = "Product"
    case security = "Security"
    case executive = "Executive Sponsor"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .engineeringManager: return "person.3.fill"
        case .developer: return "chevron.left.forwardslash.chevron.right"
        case .devops: return "server.rack"
        case .product: return "lightbulb.fill"
        case .security: return "lock.shield.fill"
        case .executive: return "chart.line.uptrend.xyaxis"
        }
    }
}

enum CompanySize: String, CaseIterable, Identifiable, Codable {
    case startup = "1–50"
    case growth = "51–250"
    case mid = "251–1,000"
    case enterprise = "1,000+"

    var id: String { rawValue }
}

enum AdoptionGoal: String, CaseIterable, Identifiable, Codable {
    case increasePRReviews = "Increase PR reviews"
    case onboardNewHires = "Onboard new hires faster"
    case reduceShadowIT = "Reduce shadow tooling"
    case driveFeatureUsage = "Drive feature usage"
    case measureROI = "Measure platform ROI"
    case standardizeWorkflows = "Standardize workflows"

    var id: String { rawValue }
}

enum AuthMethod: String, Codable {
    case email
    case sso
    case oauth
    case magicLink
    case demo
}

struct UserProfile: Identifiable, Codable, Equatable {
    var id: String
    var name: String
    var email: String
    var role: UserRole
    var company: String
    var companySize: CompanySize
    var goals: [AdoptionGoal]
    var authMethod: AuthMethod
    var plan: BillingPlan
    var mfaEnabled: Bool
    var avatarInitials: String

    static let demo = UserProfile(
        id: "usr_demo",
        name: "Alex Rivera",
        email: "alex@acme.dev",
        role: .engineeringManager,
        company: "Acme Robotics",
        companySize: .mid,
        goals: [.increasePRReviews, .driveFeatureUsage],
        authMethod: .demo,
        plan: .growth,
        mfaEnabled: false,
        avatarInitials: "AR"
    )
}

enum BillingPlan: String, CaseIterable, Identifiable, Codable {
    case free = "Free"
    case growth = "Growth"
    case enterprise = "Enterprise"

    var id: String { rawValue }

    var priceLabel: String {
        switch self {
        case .free: return "$0"
        case .growth: return "$12 / seat"
        case .enterprise: return "Custom"
        }
    }

    var features: [String] {
        switch self {
        case .free:
            return ["Up to 5 repos", "Basic adoption insights", "Email campaigns"]
        case .growth:
            return ["Unlimited repos", "In-app guides", "Slack + email campaigns", "Segment targeting"]
        case .enterprise:
            return ["SSO / SCIM", "Custom playbooks", "Dedicated CSM", "Advanced analytics"]
        }
    }
}

struct Repository: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var description: String
    var language: String
    var stars: Int
    var forks: Int
    var isPrivate: Bool
    var openPRs: Int
    var adoptionScore: Int
    var lastUpdated: String
}

struct PullRequest: Identifiable, Hashable, Codable {
    var id: String
    var number: Int
    var title: String
    var author: String
    var repoName: String
    var status: PRStatus
    var reviewers: [String]
    var checksPassing: Bool
    var additions: Int
    var deletions: Int
}

enum PRStatus: String, Codable, Hashable {
    case open, reviewRequested, approved, changesRequested, merged, closed
}

struct AdoptionMetric: Identifiable, Hashable {
    var id: String
    var title: String
    var value: String
    var delta: String
    var isPositive: Bool
}

struct FeatureAdoption: Identifiable, Hashable {
    var id: String
    var name: String
    var adoptionPercent: Int
    var trend: String
    var playbookAvailable: Bool
}

struct Campaign: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var goal: String
    var channel: CampaignChannel
    var status: CampaignStatus
    var audienceSize: Int
    var openRate: Double
    var conversionRate: Double
}

enum CampaignChannel: String, CaseIterable, Identifiable, Codable, Hashable {
    case inApp = "In-app guide"
    case email = "Email"
    case slack = "Slack"
    case multi = "Multi-channel"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .inApp: return "sparkles"
        case .email: return "envelope.fill"
        case .slack: return "bubble.left.and.bubble.right.fill"
        case .multi: return "square.stack.3d.up.fill"
        }
    }
}

enum CampaignStatus: String, Codable, Hashable {
    case draft, scheduled, live, paused, completed
}

struct TeamMember: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var email: String
    var role: String
    var lastActive: String
    var adoptionScore: Int
}

struct Integration: Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var icon: String
    var isConnected: Bool
    var category: String
}

struct AppNotification: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
    var time: String
    var kind: NotificationKind
    var isRead: Bool
}

enum NotificationKind: String, Hashable {
    case campaign, pr, invite, billing, tip
}

struct Playbook: Identifiable, Hashable {
    var id: String
    var title: String
    var summary: String
    var duration: String
    var impact: String
    var steps: [String]
}

enum OrgJoinMode: String {
    case create
    case join
}
