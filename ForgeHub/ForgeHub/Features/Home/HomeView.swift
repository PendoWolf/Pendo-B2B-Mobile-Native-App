import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.title2.bold())
                        Text(session.profile?.company ?? "Workspace")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        session.showNotifications = true
                    } label: {
                        Image(systemName: session.unreadCount > 0 ? "bell.badge.fill" : "bell.fill")
                    }
                    Button {
                        session.showGlobalSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                if session.isDemoMode {
                    StatusChip(text: "Demo workspace", color: AppTheme.accent)
                }

                if session.profile?.plan == .free {
                    Button {
                        session.showUpgradeWall = true
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Unlock Growth campaigns & playbooks")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(AppTheme.warning.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(session.metrics.prefix(4)) { metric in
                        MetricCard(metric: metric)
                    }
                }

                sectionHeader("Quick start")
                NavigationLink { QuickStartView() } label: {
                    ListRowCard {
                        Label("Finish setup checklist", systemImage: "checklist")
                            .font(.headline)
                    }
                }

                sectionHeader("Needs attention")
                ForEach(session.pullRequests.prefix(3)) { pr in
                    NavigationLink {
                        PullRequestDetailView(pr: pr)
                    } label: {
                        ListRowCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(pr.repoName) #\(pr.number)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(pr.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                StatusChip(text: pr.status.rawValue, color: prColor(pr.status))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }

                sectionHeader("Adoption pulse")
                Button {
                    session.showFeatureSpotlight = true
                } label: {
                    ListRowCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Feature spotlight")
                                    .font(.headline)
                                Text("Code Owners is underused — launch a playbook?")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "sparkle.magnifyingglass")
                                .foregroundStyle(AppTheme.brand)
                        }
                    }
                }
                .buttonStyle(.plain)

                NavigationLink {
                    ActivityDetailView(
                        title: "Campaign lift detected",
                        bodyText: "PR Review Velocity improved review response time by 14% this week."
                    )
                } label: {
                    ListRowCard {
                        Label("View activity detail", systemImage: "waveform.path.ecg")
                    }
                }
            }
            .padding(20)
        }
        .routeID(.home)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Home").font(.headline)
            }
        }
    }

    private var greeting: String {
        let name = session.profile?.name.split(separator: " ").first.map(String.init) ?? "there"
        return "Hello, \(name)"
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3.bold())
            .padding(.top, 4)
    }

    private func prColor(_ status: PRStatus) -> Color {
        switch status {
        case .approved, .merged: return AppTheme.success
        case .changesRequested: return AppTheme.danger
        case .reviewRequested: return AppTheme.warning
        default: return AppTheme.brand
        }
    }
}

struct QuickStartView: View {
    @State private var items = [
        (true, "Create organization"),
        (true, "Invite a teammate"),
        (false, "Connect Slack"),
        (false, "Launch first campaign"),
        (false, "Activate a playbook")
    ]

    var body: some View {
        List {
            Section("Workspace setup") {
                ForEach(items.indices, id: \.self) { idx in
                    HStack {
                        Image(systemName: items[idx].0 ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(items[idx].0 ? AppTheme.success : .secondary)
                        Text(items[idx].1)
                        Spacer()
                        if !items[idx].0 {
                            Button("Do it") { items[idx].0 = true }
                                .font(.caption.weight(.semibold))
                        }
                    }
                }
            }
            Section {
                NavigationLink("Connect Slack now") {
                    IntegrationDetailView(integration: SampleData.integrations[0])
                }
                NavigationLink("Create a campaign") {
                    CampaignCreateGoalView()
                }
            }
        }
        .routeID(.homeQuickStart)
        .navigationTitle("Quick start")
    }
}

struct FeatureSpotlightView: View {
    @EnvironmentObject private var session: AppSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScreenHeader(
                title: "Code Owners",
                subtitle: "Only 48% of active repos use CODEOWNERS. Teams that adopt it cut review ping-pong by ~20%."
            )

            NavigationLink("View feature adoption") {
                FeatureAdoptionDetailView(feature: SampleData.features[1])
            }
            .buttonStyle(PrimaryButtonStyle())

            NavigationLink("Activate playbook") {
                PlaybookDetailView(playbook: SampleData.playbooks[1])
            }
            .buttonStyle(SecondaryButtonStyle())

            Button("Dismiss") {
                session.showFeatureSpotlight = false
                dismiss()
            }
            .buttonStyle(GhostButtonStyle())
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(24)
        .routeID(.homeFeatureSpotlight)
        .navigationTitle("Spotlight")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivityDetailView: View {
    let title: String
    let bodyText: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ScreenHeader(title: title, subtitle: bodyText)
                ListRowCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suggested next step")
                            .font(.headline)
                        Text("Expand the campaign audience to dormant developers.")
                            .foregroundStyle(.secondary)
                    }
                }
                NavigationLink("Open campaign analytics") {
                    CampaignAnalyticsView(campaign: SampleData.campaigns[0])
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
        }
        .routeID(.homeActivityDetail)
        .navigationTitle("Activity")
    }
}
