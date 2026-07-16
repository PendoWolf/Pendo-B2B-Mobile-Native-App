import SwiftUI

struct SettingsRootView: View {
    var body: some View {
        List {
            Section("Account") {
                NavigationLink("Profile") { ProfileView() }
                NavigationLink("Notifications") { NotificationSettingsView() }
                NavigationLink("Security") { SecuritySettingsView() }
                NavigationLink("Appearance") { AppearanceSettingsView() }
            }
            Section("Support") {
                NavigationLink("Help center") { HelpCenterView() }
                NavigationLink("About ForgeHub") { AboutView() }
            }
        }
        .routeID(.settingsRoot)
        .navigationTitle("Settings")
    }
}

struct ProfileView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            if let profile = session.profile {
                Section {
                    LabeledContent("Name", value: profile.name)
                    LabeledContent("Email", value: profile.email)
                    LabeledContent("Role", value: profile.role.rawValue)
                    LabeledContent("Company", value: profile.company)
                    LabeledContent("Plan", value: profile.plan.rawValue)
                }
                Section {
                    NavigationLink("Edit profile") { ProfileEditView() }
                }
            }
        }
        .routeID(.settingsProfile)
        .navigationTitle("Profile")
    }
}

struct ProfileEditView: View {
    @EnvironmentObject private var session: AppSession
    @State private var name = ""
    @State private var company = ""

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Company", text: $company)
            }
            Section {
                Button("Save") {
                    guard var profile = session.profile else { return }
                    if !name.isEmpty { profile.name = name }
                    if !company.isEmpty { profile.company = company }
                    session.profile = profile
                }
            }
        }
        .routeID(.settingsProfileEdit)
        .navigationTitle("Edit profile")
        .onAppear {
            name = session.profile?.name ?? ""
            company = session.profile?.company ?? ""
        }
    }
}

struct NotificationSettingsView: View {
    @State private var campaigns = true
    @State private var prs = true
    @State private var billing = true
    @State private var tips = false

    var body: some View {
        Form {
            Toggle("Campaign updates", isOn: $campaigns)
            Toggle("Pull request activity", isOn: $prs)
            Toggle("Billing alerts", isOn: $billing)
            Toggle("Product tips", isOn: $tips)
        }
        .routeID(.settingsNotifications)
        .navigationTitle("Notifications")
    }
}

struct SecuritySettingsView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            Section {
                LabeledContent("MFA", value: session.profile?.mfaEnabled == true ? "On" : "Off")
                NavigationLink("Set up MFA") { MFASetupView() }
                NavigationLink("Change password") { ForgotPasswordView() }
            }
            Section {
                Button("Sign out other sessions", role: .destructive) {}
            }
        }
        .routeID(.settingsSecurity)
        .navigationTitle("Security")
    }
}

struct MFASetupView: View {
    @EnvironmentObject private var session: AppSession
    @State private var code = ""

    var body: some View {
        Form {
            Section("Authenticator app") {
                Text("Scan the QR code in your authenticator, then enter a code to confirm.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .frame(height: 160)
                    .overlay(Text("QR PLACEHOLDER").foregroundStyle(.secondary))
                TextField("Verification code", text: $code)
                    .keyboardType(.numberPad)
            }
            Section {
                Button("Enable MFA") {
                    guard var profile = session.profile else { return }
                    profile.mfaEnabled = true
                    session.profile = profile
                }
                .disabled(code.count < 6)
            }
        }
        .routeID(.settingsMFASetup)
        .navigationTitle("MFA setup")
    }
}

struct AppearanceSettingsView: View {
    @State private var theme = "System"

    var body: some View {
        Form {
            Picker("Theme", selection: $theme) {
                Text("System").tag("System")
                Text("Light").tag("Light")
                Text("Dark").tag("Dark")
            }
        }
        .routeID(.settingsAppearance)
        .navigationTitle("Appearance")
    }
}

struct HelpCenterView: View {
    var body: some View {
        List {
            NavigationLink("FAQ") { FAQView() }
            NavigationLink("Contact support") { ContactSupportView() }
            NavigationLink("Send feedback") { FeedbackView() }
        }
        .routeID(.settingsHelp)
        .navigationTitle("Help")
    }
}

struct FAQView: View {
    private let faqs = [
        ("What is ForgeHub?", "An enterprise code collaboration platform with adoption marketing built in."),
        ("How do campaigns work?", "Target segments with in-app, email, or Slack messages tied to feature goals."),
        ("Can I try before buying?", "Yes — use Explore demo workspace from the welcome screen.")
    ]

    var body: some View {
        List(faqs, id: \.0) { faq in
            VStack(alignment: .leading, spacing: 6) {
                Text(faq.0).font(.headline)
                Text(faq.1).font(.subheadline).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .routeID(.settingsFAQ)
        .navigationTitle("FAQ")
    }
}

struct ContactSupportView: View {
    @State private var subject = ""
    @State private var message = ""

    var body: some View {
        Form {
            TextField("Subject", text: $subject)
            TextField("How can we help?", text: $message, axis: .vertical)
                .lineLimit(4...8)
            Section {
                Button("Submit ticket") {}
                    .disabled(subject.isEmpty || message.isEmpty)
            }
        }
        .routeID(.settingsContact)
        .navigationTitle("Contact")
    }
}

struct FeedbackView: View {
    @State private var rating = 4
    @State private var feedback = ""

    var body: some View {
        Form {
            Stepper("Rating: \(rating)/5", value: $rating, in: 1...5)
            TextField("Feedback", text: $feedback, axis: .vertical)
                .lineLimit(3...6)
            Section {
                Button("Send feedback") {}
            }
        }
        .routeID(.settingsFeedback)
        .navigationTitle("Feedback")
    }
}

struct AboutView: View {
    var body: some View {
        List {
            LabeledContent("App", value: "ForgeHub")
            LabeledContent("Version", value: "1.0.0")
            LabeledContent("Routes", value: "\(AppRouteCatalog.routeCount)")
            Text("Built to exercise multi-path user journeys for route-scanning and adoption analytics tooling.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .routeID(.settingsAbout)
        .navigationTitle("About")
    }
}
