import SwiftUI

struct MoreRootView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            Section {
                if let profile = session.profile {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(AppTheme.brand).frame(width: 48, height: 48)
                                Text(profile.avatarInitials)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading) {
                                Text(profile.name).font(.headline)
                                Text(profile.email).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            Section("Workspace") {
                NavigationLink("Team members") { TeamMembersView() }
                NavigationLink("Billing & plans") { BillingPlansView() }
                NavigationLink("Integrations") { IntegrationsListView() }
            }

            Section("Account") {
                NavigationLink("Settings") { SettingsRootView() }
                Button("Notifications") { session.showNotifications = true }
                Button("Search") { session.showGlobalSearch = true }
            }

            Section("Explore routes") {
                NavigationLink("Route catalog") { RouteCatalogView() }
            }

            Section {
                Button("Sign out", role: .destructive) { session.signOut() }
            }
        }
        .routeID(.more)
        .navigationTitle("More")
    }
}

struct TeamMembersView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            Section {
                NavigationLink("Invite teammate") { TeamInviteView() }
                NavigationLink("Create team") { CreateTeamView() }
                NavigationLink("Roles & permissions") { TeamRolesView() }
            }
            Section("Members") {
                ForEach(session.members) { member in
                    NavigationLink {
                        TeamDetailView(member: member)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(member.name).font(.headline)
                                Text("\(member.role) · \(member.lastActive)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(member.adoptionScore)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppTheme.accent)
                        }
                    }
                }
            }
        }
        .routeID(.teamMembers)
        .navigationTitle("Team")
    }
}

struct TeamInviteView: View {
    @State private var email = ""
    @State private var role = "Developer"

    var body: some View {
        Form {
            Section("Invite") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                Picker("Role", selection: $role) {
                    ForEach(["Admin", "Maintainer", "Developer", "Viewer"], id: \.self) { Text($0) }
                }
            }
            Section {
                NavigationLink("Send invite") {
                    TeamInviteSentView(email: email.isEmpty ? "teammate@company.com" : email)
                }
                .disabled(email.isEmpty)
            }
        }
        .routeID(.teamInvite)
        .navigationTitle("Invite")
    }
}

struct TeamInviteSentView: View {
    let email: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "paperplane.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.brand)
            ScreenHeader(title: "Invite sent", subtitle: "We emailed \(email). You can track acceptance from Team.")
            NavigationLink("Back to team") { TeamMembersView() }
                .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .padding(24)
        .routeID(.teamInviteSent)
        .navigationTitle("Sent")
    }
}

struct TeamRolesView: View {
    private let roles = [
        ("Admin", "Full access including billing"),
        ("Maintainer", "Manage repos & campaigns"),
        ("Developer", "Standard contributor access"),
        ("Viewer", "Read-only insights")
    ]

    var body: some View {
        List(roles, id: \.0) { role in
            VStack(alignment: .leading, spacing: 4) {
                Text(role.0).font(.headline)
                Text(role.1).font(.caption).foregroundStyle(.secondary)
            }
        }
        .routeID(.teamRoles)
        .navigationTitle("Roles")
    }
}

struct CreateTeamView: View {
    @State private var name = ""
    @State private var purpose = "Product engineering"

    var body: some View {
        Form {
            Section {
                TextField("Team name", text: $name)
                TextField("Purpose", text: $purpose)
            }
            Section {
                NavigationLink("Create team") {
                    TeamDetailView(
                        member: TeamMember(
                            id: "team_new",
                            name: name.isEmpty ? "New Team" : name,
                            email: "team@acme.dev",
                            role: "Team",
                            lastActive: "Just now",
                            adoptionScore: 0
                        )
                    )
                }
                .disabled(name.isEmpty)
            }
        }
        .routeID(.teamCreate)
        .navigationTitle("Create team")
    }
}

struct TeamDetailView: View {
    let member: TeamMember

    var body: some View {
        List {
            Section(member.name) {
                LabeledContent("Email", value: member.email)
                LabeledContent("Role", value: member.role)
                LabeledContent("Last active", value: member.lastActive)
                LabeledContent("Adoption score", value: "\(member.adoptionScore)")
            }
            Section {
                NavigationLink("View segment overlap") {
                    SegmentDetailView(name: "Similar users", size: "12 people", summary: "Share adoption patterns with \(member.name)")
                }
                NavigationLink("Send personal nudge") { NudgesView() }
            }
        }
        .routeID(.teamDetail)
        .navigationTitle(member.name)
    }
}
