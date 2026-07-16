import SwiftUI

struct NotificationsCenterView: View {
    @EnvironmentObject private var session: AppSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                Button("Mark all as read") { session.markAllNotificationsRead() }
            }
            Section("Inbox") {
                ForEach(session.notifications) { note in
                    NavigationLink {
                        ActivityDetailView(title: note.title, bodyText: note.body)
                    } label: {
                        HStack(alignment: .top) {
                            Circle()
                                .fill(note.isRead ? Color.clear : AppTheme.brand)
                                .frame(width: 8, height: 8)
                                .padding(.top, 6)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.title).font(.subheadline.weight(.semibold))
                                Text(note.body).font(.caption).foregroundStyle(.secondary)
                                Text(note.time).font(.caption2).foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
        }
        .routeID(.notificationsCenter)
        .navigationTitle("Notifications")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
        }
    }
}

struct GlobalSearchView: View {
    @EnvironmentObject private var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        List {
            Section {
                TextField("Search repos, campaigns, people…", text: $query)
            }

            if query.isEmpty {
                Section("Quick links") {
                    NavigationLink("Repositories") { RepositoryListView() }
                    NavigationLink("Campaigns") { CampaignListView() }
                    NavigationLink("Playbooks") { PlaybookListView() }
                    NavigationLink("Team") { TeamMembersView() }
                }
            } else {
                Section("Repositories") {
                    ForEach(session.repositories.filter { $0.name.localizedCaseInsensitiveContains(query) }) { repo in
                        NavigationLink(repo.name) { RepositoryDetailView(repo: repo) }
                    }
                }
                Section("Campaigns") {
                    ForEach(session.campaigns.filter { $0.name.localizedCaseInsensitiveContains(query) }) { campaign in
                        NavigationLink(campaign.name) { CampaignDetailView(campaign: campaign) }
                    }
                }
                Section("People") {
                    ForEach(session.members.filter { $0.name.localizedCaseInsensitiveContains(query) }) { member in
                        NavigationLink(member.name) { TeamDetailView(member: member) }
                    }
                }
            }
        }
        .routeID(.globalSearch)
        .navigationTitle("Search")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
        }
    }
}
