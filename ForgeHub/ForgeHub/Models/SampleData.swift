import Foundation

enum SampleData {
    static let repositories: [Repository] = [
        Repository(id: "repo_1", name: "platform-api", description: "Core REST + GraphQL services", language: "Go", stars: 128, forks: 34, isPrivate: true, openPRs: 6, adoptionScore: 82, lastUpdated: "2h ago"),
        Repository(id: "repo_2", name: "mobile-ios", description: "Native iOS client", language: "Swift", stars: 64, forks: 12, isPrivate: true, openPRs: 3, adoptionScore: 71, lastUpdated: "5h ago"),
        Repository(id: "repo_3", name: "design-system", description: "Shared UI kit & tokens", language: "TypeScript", stars: 210, forks: 48, isPrivate: false, openPRs: 2, adoptionScore: 54, lastUpdated: "1d ago"),
        Repository(id: "repo_4", name: "infra-terraform", description: "Cloud foundation modules", language: "HCL", stars: 41, forks: 9, isPrivate: true, openPRs: 1, adoptionScore: 63, lastUpdated: "3d ago"),
        Repository(id: "repo_5", name: "docs-portal", description: "Internal developer docs", language: "MDX", stars: 33, forks: 7, isPrivate: false, openPRs: 0, adoptionScore: 39, lastUpdated: "1w ago")
    ]

    static let pullRequests: [PullRequest] = [
        PullRequest(id: "pr_1", number: 842, title: "Add branch protection adoption nudge", author: "sam.lee", repoName: "platform-api", status: .reviewRequested, reviewers: ["alex", "jordan"], checksPassing: true, additions: 214, deletions: 36),
        PullRequest(id: "pr_2", number: 319, title: "Improve empty-state CTAs for new teams", author: "morgan.k", repoName: "mobile-ios", status: .open, reviewers: ["alex"], checksPassing: false, additions: 88, deletions: 12),
        PullRequest(id: "pr_3", number: 1204, title: "Wire Slack campaign delivery", author: "riley.p", repoName: "platform-api", status: .approved, reviewers: ["alex", "casey"], checksPassing: true, additions: 156, deletions: 40),
        PullRequest(id: "pr_4", number: 77, title: "Document playbook activation API", author: "jamie.t", repoName: "docs-portal", status: .changesRequested, reviewers: ["morgan.k"], checksPassing: true, additions: 42, deletions: 5)
    ]

    static let campaigns: [Campaign] = [
        Campaign(id: "cmp_1", name: "PR Review Velocity", goal: "Increase PR reviews", channel: .multi, status: .live, audienceSize: 128, openRate: 0.62, conversionRate: 0.18),
        Campaign(id: "cmp_2", name: "Code Owners Rollout", goal: "Standardize workflows", channel: .inApp, status: .scheduled, audienceSize: 86, openRate: 0, conversionRate: 0),
        Campaign(id: "cmp_3", name: "New Hire Week 1", goal: "Onboard new hires faster", channel: .email, status: .completed, audienceSize: 24, openRate: 0.81, conversionRate: 0.44),
        Campaign(id: "cmp_4", name: "Actions Adoption Push", goal: "Drive feature usage", channel: .slack, status: .paused, audienceSize: 210, openRate: 0.47, conversionRate: 0.09)
    ]

    static let members: [TeamMember] = [
        TeamMember(id: "m1", name: "Alex Rivera", email: "alex@acme.dev", role: "Admin", lastActive: "Now", adoptionScore: 94),
        TeamMember(id: "m2", name: "Sam Lee", email: "sam@acme.dev", role: "Maintainer", lastActive: "12m ago", adoptionScore: 81),
        TeamMember(id: "m3", name: "Jordan Blake", email: "jordan@acme.dev", role: "Developer", lastActive: "1h ago", adoptionScore: 67),
        TeamMember(id: "m4", name: "Casey Ng", email: "casey@acme.dev", role: "Developer", lastActive: "Yesterday", adoptionScore: 42),
        TeamMember(id: "m5", name: "Riley Patel", email: "riley@acme.dev", role: "Viewer", lastActive: "3d ago", adoptionScore: 28)
    ]

    static let integrations: [Integration] = [
        Integration(id: "int_slack", name: "Slack", description: "Send adoption nudges to channels & DMs", icon: "number", isConnected: true, category: "Communication"),
        Integration(id: "int_jira", name: "Jira", description: "Link issues to pull requests and campaigns", icon: "ticket", isConnected: false, category: "Project tracking"),
        Integration(id: "int_okta", name: "Okta", description: "SSO and SCIM provisioning", icon: "person.badge.key", isConnected: false, category: "Identity"),
        Integration(id: "int_datadog", name: "Datadog", description: "Correlate usage with engineering metrics", icon: "waveform.path.ecg", isConnected: true, category: "Observability"),
        Integration(id: "int_email", name: "Work Email", description: "Transactional and nurture email sends", icon: "envelope.badge", isConnected: true, category: "Communication")
    ]

    static let notifications: [AppNotification] = [
        AppNotification(id: "n1", title: "Campaign live", body: "PR Review Velocity is now live for 128 users.", time: "8m ago", kind: .campaign, isRead: false),
        AppNotification(id: "n2", title: "Review requested", body: "sam.lee requested your review on #842.", time: "22m ago", kind: .pr, isRead: false),
        AppNotification(id: "n3", title: "Invite accepted", body: "Casey Ng joined Acme Robotics.", time: "2h ago", kind: .invite, isRead: true),
        AppNotification(id: "n4", title: "Trial tip", body: "Teams on Growth launch 2.4× more playbooks.", time: "1d ago", kind: .tip, isRead: true),
        AppNotification(id: "n5", title: "Billing", body: "Your Growth trial ends in 9 days.", time: "2d ago", kind: .billing, isRead: false)
    ]

    static let playbooks: [Playbook] = [
        Playbook(id: "pb1", title: "First PR in 7 Days", summary: "Guide new hires from clone to merged PR.", duration: "7 days", impact: "High", steps: ["Welcome guide", "Repo tour", "Draft PR checklist", "Reviewer match", "Merge celebration"]),
        Playbook(id: "pb2", title: "Branch Protection Basics", summary: "Roll out required reviews without friction.", duration: "3 days", impact: "Medium", steps: ["Explain why", "Soft-enable", "Exempt power users", "Enforce", "Report lift"]),
        Playbook(id: "pb3", title: "Actions Power Users", summary: "Move CI scripts into reusable workflows.", duration: "14 days", impact: "High", steps: ["Discover heavy CI users", "Template library", "Migration guide", "Office hours", "Deprecate scripts"]),
        Playbook(id: "pb4", title: "Re-engage Dormant Devs", summary: "Win back seats with low weekly activity.", duration: "10 days", impact: "Medium", steps: ["Segment dormant", "Personal Slack nudge", "Manager digest", "Office hours invite", "Measure return"])
    ]

    static let features: [FeatureAdoption] = [
        FeatureAdoption(id: "f1", name: "Pull Requests", adoptionPercent: 91, trend: "+4%", playbookAvailable: false),
        FeatureAdoption(id: "f2", name: "Code Owners", adoptionPercent: 48, trend: "+11%", playbookAvailable: true),
        FeatureAdoption(id: "f3", name: "Actions / CI", adoptionPercent: 62, trend: "+2%", playbookAvailable: true),
        FeatureAdoption(id: "f4", name: "Security Scanning", adoptionPercent: 33, trend: "-1%", playbookAvailable: true),
        FeatureAdoption(id: "f5", name: "Project Boards", adoptionPercent: 27, trend: "+6%", playbookAvailable: true),
        FeatureAdoption(id: "f6", name: "Discussions", adoptionPercent: 18, trend: "+9%", playbookAvailable: true)
    ]

    static let metrics: [AdoptionMetric] = [
        AdoptionMetric(id: "met1", title: "Weekly active developers", value: "186", delta: "+12%", isPositive: true),
        AdoptionMetric(id: "met2", title: "Avg. PR cycle time", value: "1.8d", delta: "-9%", isPositive: true),
        AdoptionMetric(id: "met3", title: "Feature depth score", value: "64", delta: "+5", isPositive: true),
        AdoptionMetric(id: "met4", title: "Dormant seats", value: "41", delta: "+3", isPositive: false)
    ]
}
