import SwiftUI

struct CampaignListView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        Group {
            if session.campaigns.isEmpty {
                EmptyStateView(
                    icon: "megaphone",
                    title: "No campaigns yet",
                    message: "Launch in-app, email, or Slack campaigns to drive feature adoption.",
                    cta: "Create campaign"
                ) {}
                .routeID(.campaignEmptyState)
            } else {
                List {
                    Section {
                        NavigationLink("Create campaign") { CampaignCreateGoalView() }
                    }
                    Section("Campaigns") {
                        ForEach(session.campaigns) { campaign in
                            NavigationLink {
                                CampaignDetailView(campaign: campaign)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(campaign.name).font(.headline)
                                        Spacer()
                                        StatusChip(text: campaign.status.rawValue, color: statusColor(campaign.status))
                                    }
                                    Text("\(campaign.channel.rawValue) · \(campaign.audienceSize) people")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
            }
        }
        .routeID(.campaigns)
        .navigationTitle("Campaigns")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink { CampaignCreateGoalView() } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func statusColor(_ status: CampaignStatus) -> Color {
        switch status {
        case .live: return AppTheme.success
        case .paused: return AppTheme.warning
        case .completed: return AppTheme.muted
        case .scheduled: return AppTheme.brand
        case .draft: return .secondary
        }
    }
}

struct CampaignCreateGoalView: View {
    var prefillGoal: String? = nil
    @State private var goal: String = ""

    var body: some View {
        Form {
            Section("What's the goal?") {
                TextField("Goal", text: $goal)
                ForEach(AdoptionGoal.allCases) { g in
                    Button(g.rawValue) { goal = g.rawValue }
                }
            }
            Section {
                NavigationLink("Continue") {
                    CampaignCreateAudienceView(prefillGoal: goal.isEmpty ? (prefillGoal ?? "Drive feature usage") : goal)
                }
            }
        }
        .routeID(.campaignCreateGoal)
        .navigationTitle("Goal")
        .onAppear {
            if goal.isEmpty, let prefillGoal { goal = prefillGoal }
        }
    }
}

struct CampaignCreateAudienceView: View {
    var prefillGoal: String = "Drive feature usage"
    var prefillAudience: String? = nil
    @State private var audience = "Dormant seats"

    var body: some View {
        Form {
            Section("Audience") {
                Picker("Segment", selection: $audience) {
                    Text("All developers").tag("All developers")
                    Text("New hires").tag("New hires")
                    Text("Dormant seats").tag("Dormant seats")
                    Text("Managers").tag("Managers")
                    Text("Power users").tag("Power users")
                }
            }
            Section {
                NavigationLink("Continue") {
                    CampaignCreateChannelView(goal: prefillGoal, audience: audience)
                }
            }
        }
        .routeID(.campaignCreateAudience)
        .navigationTitle("Audience")
        .onAppear {
            if let prefillAudience { audience = prefillAudience }
        }
    }
}

struct CampaignCreateChannelView: View {
    let goal: String
    let audience: String
    @State private var channel: CampaignChannel = .inApp

    var body: some View {
        Form {
            Section("Channel") {
                ForEach(CampaignChannel.allCases) { ch in
                    Button {
                        channel = ch
                    } label: {
                        HStack {
                            Label(ch.rawValue, systemImage: ch.icon)
                            Spacer()
                            if channel == ch {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(AppTheme.brand)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            Section {
                NavigationLink("Continue") {
                    CampaignCreateContentView(goal: goal, audience: audience, channel: channel)
                }
            }
        }
        .routeID(.campaignCreateChannel)
        .navigationTitle("Channel")
    }
}

struct CampaignCreateContentView: View {
    let goal: String
    let audience: String
    let channel: CampaignChannel
    @State private var headline = "Ready to level up your workflow?"
    @State private var bodyText = "Teams using this feature ship faster. Here's a 2-minute guide."

    var body: some View {
        Form {
            Section("Content") {
                TextField("Headline", text: $headline)
                TextField("Body", text: $bodyText, axis: .vertical)
                    .lineLimit(4...8)
            }
            Section {
                NavigationLink("Continue") {
                    CampaignCreateScheduleView(
                        goal: goal,
                        audience: audience,
                        channel: channel,
                        headline: headline,
                        bodyText: bodyText
                    )
                }
            }
        }
        .routeID(.campaignCreateContent)
        .navigationTitle("Content")
    }
}

struct CampaignCreateScheduleView: View {
    let goal: String
    let audience: String
    let channel: CampaignChannel
    let headline: String
    let bodyText: String
    @State private var when = "Launch now"
    @State private var date = Date()

    var body: some View {
        Form {
            Section("Schedule") {
                Picker("When", selection: $when) {
                    Text("Launch now").tag("Launch now")
                    Text("Schedule").tag("Schedule")
                }
                if when == "Schedule" {
                    DatePicker("Start", selection: $date)
                }
            }
            Section {
                NavigationLink("Review") {
                    CampaignCreateReviewView(
                        goal: goal,
                        audience: audience,
                        channel: channel,
                        headline: headline,
                        bodyText: bodyText,
                        when: when
                    )
                }
            }
        }
        .routeID(.campaignCreateSchedule)
        .navigationTitle("Schedule")
    }
}

struct CampaignCreateReviewView: View {
    @EnvironmentObject private var session: AppSession
    let goal: String
    let audience: String
    let channel: CampaignChannel
    let headline: String
    let bodyText: String
    let when: String

    var body: some View {
        List {
            Section("Review") {
                LabeledContent("Goal", value: goal)
                LabeledContent("Audience", value: audience)
                LabeledContent("Channel", value: channel.rawValue)
                LabeledContent("Timing", value: when)
                Text(headline).font(.headline)
                Text(bodyText).foregroundStyle(.secondary)
            }
            Section {
                Button("Launch campaign") {
                    let campaign = Campaign(
                        id: "cmp_\(UUID().uuidString.prefix(5))",
                        name: headline,
                        goal: goal,
                        channel: channel,
                        status: when == "Launch now" ? .live : .scheduled,
                        audienceSize: 64,
                        openRate: 0,
                        conversionRate: 0
                    )
                    session.addCampaign(campaign)
                    session.selectedTab = .campaigns
                }
            }
        }
        .routeID(.campaignCreateReview)
        .navigationTitle("Review")
    }
}

struct CampaignDetailView: View {
    let campaign: Campaign

    var body: some View {
        List {
            Section(campaign.name) {
                LabeledContent("Status", value: campaign.status.rawValue)
                LabeledContent("Channel", value: campaign.channel.rawValue)
                LabeledContent("Goal", value: campaign.goal)
                LabeledContent("Audience", value: "\(campaign.audienceSize)")
            }
            Section {
                NavigationLink("Analytics") { CampaignAnalyticsView(campaign: campaign) }
                NavigationLink("A/B test variants") { CampaignABTestView(campaign: campaign) }
            }
            Section("Controls") {
                Button("Pause campaign") {}
                Button("Duplicate campaign") {}
            }
        }
        .routeID(.campaignDetail)
        .navigationTitle("Campaign")
    }
}

struct CampaignAnalyticsView: View {
    let campaign: Campaign

    var body: some View {
        List {
            Section("Performance") {
                LabeledContent("Open rate", value: percent(campaign.openRate))
                LabeledContent("Conversion", value: percent(campaign.conversionRate))
                LabeledContent("Audience", value: "\(campaign.audienceSize)")
            }
            Section("Funnel") {
                Text("Delivered → Opened → Clicked → Converted")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ProgressView(value: max(campaign.conversionRate, 0.05))
                    .tint(AppTheme.brand)
            }
            Section {
                NavigationLink("Optimize with A/B test") { CampaignABTestView(campaign: campaign) }
            }
        }
        .routeID(.campaignAnalytics)
        .navigationTitle("Analytics")
    }

    private func percent(_ value: Double) -> String {
        String(format: "%.0f%%", value * 100)
    }
}

struct CampaignABTestView: View {
    let campaign: Campaign
    @State private var variantB = "Shorter headline + stronger CTA"

    var body: some View {
        Form {
            Section("Variant A (control)") {
                Text(campaign.name)
            }
            Section("Variant B") {
                TextField("Hypothesis", text: $variantB, axis: .vertical)
                    .lineLimit(2...4)
            }
            Section {
                Button("Start A/B test") {}
            }
        }
        .routeID(.campaignABTest)
        .navigationTitle("A/B test")
    }
}
