import SwiftUI

struct AdoptionOverviewView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(
                    title: "Adoption",
                    subtitle: "Measure depth of platform usage and launch playbooks that move the needle."
                )

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(session.metrics) { metric in
                        MetricCard(metric: metric)
                    }
                }

                NavigationLink { FeatureAdoptionListView() } label: {
                    ListRowCard { Label("Feature adoption", systemImage: "square.grid.2x2.fill") }
                }
                NavigationLink { SegmentListView() } label: {
                    ListRowCard { Label("User segments", systemImage: "person.3.sequence.fill") }
                }
                NavigationLink { PlaybookListView() } label: {
                    ListRowCard { Label("Playbooks", systemImage: "book.closed.fill") }
                }
                NavigationLink { NudgesView() } label: {
                    ListRowCard { Label("Recommended nudges", systemImage: "bell.and.waves.left.and.right.fill") }
                }
            }
            .padding(20)
        }
        .routeID(.adoption)
        .navigationTitle("Adoption")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureAdoptionListView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List(session.features) { feature in
            NavigationLink {
                FeatureAdoptionDetailView(feature: feature)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(feature.name).font(.headline)
                        Spacer()
                        Text("\(feature.adoptionPercent)%")
                            .fontWeight(.semibold)
                    }
                    ProgressView(value: Double(feature.adoptionPercent), total: 100)
                        .tint(AppTheme.brand)
                    HStack {
                        Text(feature.trend).font(.caption).foregroundStyle(AppTheme.success)
                        if feature.playbookAvailable {
                            StatusChip(text: "Playbook", color: AppTheme.accent)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .routeID(.adoptionFeatures)
        .navigationTitle("Features")
    }
}

struct FeatureAdoptionDetailView: View {
    let feature: FeatureAdoption

    var body: some View {
        List {
            Section(feature.name) {
                LabeledContent("Adoption", value: "\(feature.adoptionPercent)%")
                LabeledContent("Trend", value: feature.trend)
            }
            Section("Insights") {
                Text("Power users cluster in Platform Engineering. Dormant usage is highest among new hires week 3–6.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if feature.playbookAvailable {
                Section {
                    NavigationLink("Browse related playbooks") { PlaybookListView() }
                    NavigationLink("Create campaign for this feature") { CampaignCreateGoalView(prefillGoal: feature.name) }
                }
            }
        }
        .routeID(.adoptionFeatureDetail)
        .navigationTitle(feature.name)
    }
}

struct SegmentListView: View {
    private let segments = [
        ("Power users", "42 people", "High depth, good champions"),
        ("New hires", "18 people", "First 30 days"),
        ("Dormant seats", "41 people", "No activity in 14 days"),
        ("Managers", "22 people", "Review bottlenecks")
    ]

    var body: some View {
        List(segments, id: \.0) { segment in
            NavigationLink {
                SegmentDetailView(name: segment.0, size: segment.1, summary: segment.2)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(segment.0).font(.headline)
                    Text("\(segment.1) · \(segment.2)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .routeID(.adoptionSegments)
        .navigationTitle("Segments")
    }
}

struct SegmentDetailView: View {
    let name: String
    let size: String
    let summary: String

    var body: some View {
        List {
            Section(name) {
                LabeledContent("Size", value: size)
                Text(summary).foregroundStyle(.secondary)
            }
            Section {
                NavigationLink("Target with campaign") { CampaignCreateAudienceView(prefillAudience: name) }
                NavigationLink("Recommended nudges") { NudgesView() }
            }
        }
        .routeID(.adoptionSegmentDetail)
        .navigationTitle(name)
    }
}

struct PlaybookListView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List(session.playbooks) { playbook in
            NavigationLink {
                PlaybookDetailView(playbook: playbook)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(playbook.title).font(.headline)
                    Text(playbook.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        StatusChip(text: playbook.duration)
                        StatusChip(text: "\(playbook.impact) impact", color: AppTheme.accent)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .routeID(.adoptionPlaybooks)
        .navigationTitle("Playbooks")
    }
}

struct PlaybookDetailView: View {
    let playbook: Playbook

    var body: some View {
        List {
            Section {
                Text(playbook.summary)
                LabeledContent("Duration", value: playbook.duration)
                LabeledContent("Impact", value: playbook.impact)
            }
            Section("Steps") {
                ForEach(Array(playbook.steps.enumerated()), id: \.offset) { idx, step in
                    Text("\(idx + 1). \(step)")
                }
            }
            Section {
                NavigationLink("Activate playbook") {
                    PlaybookActivateView(playbook: playbook)
                }
            }
        }
        .routeID(.adoptionPlaybookDetail)
        .navigationTitle(playbook.title)
    }
}

struct PlaybookActivateView: View {
    @EnvironmentObject private var session: AppSession
    let playbook: Playbook
    @State private var audience = "New hires"
    @State private var startNow = true

    var body: some View {
        Form {
            Section("Activate \(playbook.title)") {
                Picker("Audience", selection: $audience) {
                    Text("New hires").tag("New hires")
                    Text("Dormant seats").tag("Dormant seats")
                    Text("All developers").tag("All developers")
                }
                Toggle("Start immediately", isOn: $startNow)
            }
            Section {
                Button("Launch playbook") {
                    session.selectedTab = .adoption
                }
                NavigationLink("Also create a campaign") {
                    CampaignCreateGoalView(prefillGoal: playbook.title)
                }
            }
        }
        .routeID(.adoptionPlaybookActivate)
        .navigationTitle("Activate")
    }
}

struct NudgesView: View {
    private let nudges = [
        ("Ask Casey to open a first PR", "Low adoption · New hire"),
        ("Remind managers about review SLAs", "PR cycle time rising"),
        ("Promote Actions templates in Slack", "CI feature depth low"),
        ("Invite dormant seats to office hours", "41 inactive seats")
    ]

    var body: some View {
        List(nudges, id: \.0) { nudge in
            NavigationLink {
                ActivityDetailView(title: nudge.0, bodyText: nudge.1)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nudge.0).font(.subheadline.weight(.semibold))
                    Text(nudge.1).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .routeID(.adoptionNudges)
        .navigationTitle("Nudges")
    }
}
