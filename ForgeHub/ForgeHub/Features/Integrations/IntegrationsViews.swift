import SwiftUI

struct IntegrationsListView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List(session.integrations) { integration in
            NavigationLink {
                IntegrationDetailView(integration: integration)
            } label: {
                HStack {
                    Image(systemName: integration.icon)
                        .foregroundStyle(AppTheme.brand)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(integration.name).font(.headline)
                        Text(integration.category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    StatusChip(
                        text: integration.isConnected ? "Connected" : "Available",
                        color: integration.isConnected ? AppTheme.success : .secondary
                    )
                }
            }
        }
        .routeID(.integrationsList)
        .navigationTitle("Integrations")
    }
}

struct IntegrationDetailView: View {
    @EnvironmentObject private var session: AppSession
    let integration: Integration

    private var live: Integration {
        session.integrations.first(where: { $0.id == integration.id }) ?? integration
    }

    var body: some View {
        List {
            Section(live.name) {
                Text(live.description)
                LabeledContent("Category", value: live.category)
                LabeledContent("Status", value: live.isConnected ? "Connected" : "Not connected")
            }
            Section {
                if live.isConnected {
                    NavigationLink("Configure") {
                        IntegrationConfigureView(integration: live)
                    }
                    Button("Disconnect", role: .destructive) {
                        session.toggleIntegration(live.id)
                    }
                } else {
                    NavigationLink("Connect") {
                        IntegrationConnectView(integration: live)
                    }
                }
            }
        }
        .routeID(.integrationDetail)
        .navigationTitle(live.name)
    }
}

struct IntegrationConnectView: View {
    let integration: Integration
    @State private var workspace = ""

    var body: some View {
        Form {
            Section("Connect \(integration.name)") {
                TextField("Workspace / account", text: $workspace)
                Text("You'll authorize ForgeHub to send adoption messages and sync usage signals.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section {
                NavigationLink("Authorize") {
                    IntegrationConfigureView(integration: integration, justConnected: true)
                }
                .disabled(workspace.isEmpty)
            }
        }
        .routeID(.integrationConnect)
        .navigationTitle("Connect")
    }
}

struct IntegrationConfigureView: View {
    @EnvironmentObject private var session: AppSession
    let integration: Integration
    var justConnected: Bool = false
    @State private var channel = "#eng-adoption"
    @State private var digest = true

    var body: some View {
        Form {
            Section("Configuration") {
                TextField("Default channel / project", text: $channel)
                Toggle("Weekly digest", isOn: $digest)
            }
            Section {
                if justConnected {
                    NavigationLink("Save & finish") {
                        IntegrationSuccessView(name: integration.name)
                    }
                    .onAppear {
                        if !integration.isConnected {
                            session.toggleIntegration(integration.id)
                        }
                    }
                } else {
                    Button("Save changes") {}
                }
            }
        }
        .routeID(.integrationConfigure)
        .navigationTitle("Configure")
    }
}

struct IntegrationSuccessView: View {
    let name: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "link.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.success)
            ScreenHeader(title: "\(name) connected", subtitle: "You can now deliver campaigns and nudges through this integration.")
            NavigationLink("Back to integrations") { IntegrationsListView() }
                .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .padding(24)
        .routeID(.integrationSuccess)
        .navigationTitle("Connected")
        .navigationBarBackButtonHidden(true)
    }
}
