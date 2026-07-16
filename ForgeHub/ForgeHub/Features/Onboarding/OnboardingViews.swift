import SwiftUI

struct OnboardingRoleView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressDots(total: 6, current: 0)
                ScreenHeader(title: "What's your role?", subtitle: "We'll tailor adoption playbooks to how you work.")

                ForEach(UserRole.allCases) { role in
                    Button {
                        session.draftRole = role
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: role.icon)
                                .frame(width: 28)
                            Text(role.rawValue)
                                .font(.body.weight(.medium))
                            Spacer()
                            if session.draftRole == role {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppTheme.brand)
                            }
                        }
                        .padding()
                        .background(session.draftRole == role ? AppTheme.brand.opacity(0.12) : AppTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("onboarding.role.\(role.rawValue)")
                }

                NavigationLink("Continue") { OnboardingCompanyView() }
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
        }
        .routeID(.onboardingRole)
        .navigationTitle("Onboarding")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OnboardingCompanyView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressDots(total: 6, current: 1)
                ScreenHeader(title: "Company size", subtitle: "Helps us recommend the right rollout pattern.")

                ForEach(CompanySize.allCases) { size in
                    Button {
                        session.draftCompanySize = size
                    } label: {
                        HStack {
                            Text(size.rawValue + " employees")
                            Spacer()
                            if session.draftCompanySize == size {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppTheme.brand)
                            }
                        }
                        .padding()
                        .background(session.draftCompanySize == size ? AppTheme.brand.opacity(0.12) : AppTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                NavigationLink("Continue") { OnboardingGoalsView() }
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
        }
        .routeID(.onboardingCompany)
        .navigationTitle("Company")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OnboardingGoalsView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressDots(total: 6, current: 2)
                ScreenHeader(title: "Adoption goals", subtitle: "Pick one or more outcomes to optimize for.")

                ForEach(AdoptionGoal.allCases) { goal in
                    Button {
                        if session.draftGoals.contains(goal) {
                            session.draftGoals.remove(goal)
                        } else {
                            session.draftGoals.insert(goal)
                        }
                    } label: {
                        HStack {
                            Text(goal.rawValue)
                            Spacer()
                            Image(systemName: session.draftGoals.contains(goal) ? "checkmark.square.fill" : "square")
                                .foregroundStyle(AppTheme.brand)
                        }
                        .padding()
                        .background(AppTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                NavigationLink("Continue") { OnboardingAuthChoiceView() }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(session.draftGoals.isEmpty)
                    .opacity(session.draftGoals.isEmpty ? 0.5 : 1)
            }
            .padding(24)
        }
        .routeID(.onboardingGoals)
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OnboardingAuthChoiceView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProgressDots(total: 6, current: 3)
                ScreenHeader(title: "How will you sign up?", subtitle: "Multiple auth paths — each continues into org setup.")

                authOption(title: "Work email", subtitle: "Password-based account", method: .email, icon: "envelope.fill", destination: AnyView(EmailSignUpView(fromOnboarding: true)))
                authOption(title: "Company SSO", subtitle: "Okta, Azure AD, OneLogin", method: .sso, icon: "building.2.fill", destination: AnyView(SSOSignInView(fromOnboarding: true)))
                authOption(title: "Continue with OAuth", subtitle: "GitHub, Google, Microsoft", method: .oauth, icon: "person.crop.circle.badge.checkmark", destination: AnyView(OAuthSignInView(fromOnboarding: true)))
                authOption(title: "Magic link", subtitle: "Passwordless email link", method: .magicLink, icon: "link", destination: AnyView(MagicLinkView(fromOnboarding: true)))
            }
            .padding(24)
        }
        .routeID(.onboardingAuthChoice)
        .navigationTitle("Sign up")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func authOption(title: String, subtitle: String, method: AuthMethod, icon: String, destination: AnyView) -> some View {
        NavigationLink {
            destination
                .onAppear { session.draftAuthMethod = method }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.brand)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.body.weight(.semibold))
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.tertiary)
            }
            .padding()
            .background(AppTheme.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("onboarding.auth.\(method.rawValue)")
    }
}

struct OnboardingOrgChoiceView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressDots(total: 6, current: 4)
            ScreenHeader(title: "Set up your workspace", subtitle: "Create a new org or join one with an invite code.")

            NavigationLink {
                OnboardingCreateOrgView()
                    .onAppear { session.draftJoinMode = .create }
            } label: {
                orgCard(title: "Create organization", subtitle: "Start a new ForgeHub workspace", icon: "plus.circle.fill")
            }
            .buttonStyle(.plain)

            NavigationLink {
                OnboardingJoinOrgView()
                    .onAppear { session.draftJoinMode = .join }
            } label: {
                orgCard(title: "Join with invite code", subtitle: "Enter a code from your admin", icon: "ticket.fill")
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(24)
        .routeID(.onboardingOrgChoice)
        .navigationTitle("Organization")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func orgCard(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppTheme.brand)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(AppTheme.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct OnboardingCreateOrgView: View {
    @EnvironmentObject private var session: AppSession
    @State private var orgName = ""

    var body: some View {
        Form {
            Section("Organization") {
                TextField("Company or team name", text: $orgName)
                TextField("Slug (optional)", text: .constant("acme-robotics"))
                    .disabled(true)
                    .foregroundStyle(.secondary)
            }
            Section {
                NavigationLink("Create & continue") {
                    OnboardingInviteTeamView()
                        .onAppear { session.draftCompanyName = orgName }
                }
                .disabled(orgName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .routeID(.onboardingCreateOrg)
        .navigationTitle("Create org")
    }
}

struct OnboardingJoinOrgView: View {
    @EnvironmentObject private var session: AppSession
    @State private var code = ""

    var body: some View {
        Form {
            Section("Invite code") {
                TextField("e.g. ACME-7F2K", text: $code)
                    .textInputAutocapitalization(.characters)
            }
            Section {
                NavigationLink("Join & continue") {
                    OnboardingInviteTeamView()
                        .onAppear {
                            session.draftOrgCode = code
                            session.draftCompanyName = "Acme Robotics"
                        }
                }
                .disabled(code.count < 4)
            }
            Section {
                NavigationLink("Don't have a code? Create an org") {
                    OnboardingCreateOrgView()
                }
            }
        }
        .routeID(.onboardingJoinOrg)
        .navigationTitle("Join org")
    }
}

struct OnboardingInviteTeamView: View {
    @State private var emails = ""

    var body: some View {
        Form {
            Section("Invite teammates (optional)") {
                TextField("Emails, comma-separated", text: $emails, axis: .vertical)
                    .lineLimit(3...6)
            }
            Section {
                NavigationLink("Send invites") { OnboardingFirstRepoView() }
                NavigationLink("Skip for now") { OnboardingFirstRepoView() }
            }
        }
        .routeID(.onboardingInviteTeam)
        .navigationTitle("Invite team")
    }
}

struct OnboardingFirstRepoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressDots(total: 6, current: 5)
            ScreenHeader(title: "Add your first repository", subtitle: "Create one now, import later, or skip.")

            NavigationLink {
                CreateRepositoryView(completesOnboarding: true)
            } label: {
                row(icon: "plus.rectangle.on.folder", title: "Create repository")
            }

            NavigationLink {
                ImportRepositoryView(completesOnboarding: true)
            } label: {
                row(icon: "square.and.arrow.down", title: "Import existing repo")
            }

            NavigationLink {
                OnboardingCompleteView()
            } label: {
                row(icon: "arrow.right.circle", title: "Skip — go to workspace")
            }

            Spacer()
        }
        .padding(24)
        .routeID(.onboardingFirstRepo)
        .navigationTitle("First repo")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(AppTheme.brand).frame(width: 28)
            Text(title).font(.headline)
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        .padding()
        .background(AppTheme.surfaceSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct OnboardingCompleteView: View {
    @EnvironmentObject private var session: AppSession
    @State private var name = "Alex Rivera"
    @State private var email = "alex@acme.dev"

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.success)

            ScreenHeader(
                title: "You're ready to ship",
                subtitle: "Your workspace is set up. Explore adoption insights, launch campaigns, and grow platform usage."
            )

            VStack(alignment: .leading, spacing: 12) {
                TextField("Display name", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }

            Button("Enter ForgeHub") {
                session.completeOnboarding(name: name, email: email)
            }
            .buttonStyle(PrimaryButtonStyle())
            .accessibilityIdentifier("cta.enterApp")

            Spacer()
        }
        .padding(24)
        .routeID(.onboardingComplete)
        .navigationTitle("Complete")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}
