import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var session: AppSession
    @State private var email = "alex@acme.dev"
    @State private var password = "password"
    @State private var requireMFA = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(title: "Sign in", subtitle: "Returning users can branch into MFA, reset, SSO, or OAuth.")

                TextField("Work email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Toggle("Simulate MFA challenge", isOn: $requireMFA)

                if requireMFA {
                    NavigationLink("Sign in") {
                        MFAChallengeView()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Button("Sign in") {
                        session.signIn(as: .demo, requireMFA: false)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                NavigationLink("Forgot password?") { ForgotPasswordView() }
                    .font(.subheadline.weight(.semibold))

                Divider().padding(.vertical, 4)

                NavigationLink("Sign in with SSO") { SSOSignInView(fromOnboarding: false) }
                    .buttonStyle(SecondaryButtonStyle())

                NavigationLink("Continue with OAuth") { OAuthSignInView(fromOnboarding: false) }
                    .buttonStyle(SecondaryButtonStyle())

                NavigationLink("Email me a magic link") { MagicLinkView(fromOnboarding: false) }
                    .buttonStyle(GhostButtonStyle())
                    .frame(maxWidth: .infinity)

                Button("Back to welcome") { session.phase = .welcome }
                    .buttonStyle(GhostButtonStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            .padding(24)
        }
        .routeID(.authSignIn)
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmailSignUpView: View {
    @EnvironmentObject private var session: AppSession
    var fromOnboarding: Bool
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        Form {
            Section("Create account") {
                TextField("Full name", text: $name)
                TextField("Work email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
            }
            Section {
                if fromOnboarding {
                    NavigationLink("Create account") {
                        OnboardingOrgChoiceView()
                            .onAppear { session.draftAuthMethod = .email }
                    }
                    .disabled(email.isEmpty || password.count < 6)
                } else {
                    Button("Create account") {
                        session.completeOnboarding(name: name, email: email)
                    }
                    .disabled(email.isEmpty || password.count < 6)
                }
            }
        }
        .routeID(.authEmailSignUp)
        .navigationTitle("Email sign up")
    }
}

struct SSOSignInView: View {
    @EnvironmentObject private var session: AppSession
    var fromOnboarding: Bool
    @State private var domain = "acme.dev"

    var body: some View {
        Form {
            Section("Enterprise SSO") {
                TextField("Company email domain", text: $domain)
                    .textInputAutocapitalization(.never)
                Text("We'll redirect to your identity provider.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section {
                if fromOnboarding {
                    NavigationLink("Continue to SSO") { OnboardingOrgChoiceView() }
                } else {
                    Button("Continue to SSO") { session.signIn() }
                }
            }
            Section("Providers") {
                Label("Okta", systemImage: "building.columns")
                Label("Azure Active Directory", systemImage: "cloud")
                Label("OneLogin", systemImage: "key.fill")
            }
        }
        .routeID(.authSSO)
        .navigationTitle("SSO")
    }
}

struct OAuthSignInView: View {
    @EnvironmentObject private var session: AppSession
    var fromOnboarding: Bool

    var body: some View {
        VStack(spacing: 14) {
            ScreenHeader(title: "Choose a provider", subtitle: "OAuth continues into onboarding or straight to the app.")

            provider("GitHub", icon: "chevron.left.forwardslash.chevron.right")
            provider("Google", icon: "globe")
            provider("Microsoft", icon: "laptopcomputer")

            Spacer()
        }
        .padding(24)
        .routeID(.authOAuth)
        .navigationTitle("OAuth")
    }

    private func provider(_ name: String, icon: String) -> some View {
        Group {
            if fromOnboarding {
                NavigationLink {
                    OnboardingOrgChoiceView()
                } label: {
                    Label("Continue with \(name)", systemImage: icon)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(SecondaryButtonStyle())
            } else {
                Button {
                    session.signIn()
                } label: {
                    Label("Continue with \(name)", systemImage: icon)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }
}

struct MagicLinkView: View {
    var fromOnboarding: Bool
    @State private var email = ""

    var body: some View {
        Form {
            Section("Magic link") {
                TextField("Work email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            Section {
                NavigationLink("Send magic link") {
                    MagicLinkSentView(fromOnboarding: fromOnboarding, email: email)
                }
                .disabled(email.isEmpty)
            }
        }
        .routeID(.authMagicLink)
        .navigationTitle("Magic link")
    }
}

struct MagicLinkSentView: View {
    @EnvironmentObject private var session: AppSession
    var fromOnboarding: Bool
    var email: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope.open.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.brand)

            ScreenHeader(
                title: "Check your inbox",
                subtitle: "We sent a sign-in link to \(email.isEmpty ? "your email" : email)."
            )

            if fromOnboarding {
                NavigationLink("Simulate link open") { OnboardingOrgChoiceView() }
                    .buttonStyle(PrimaryButtonStyle())
            } else {
                Button("Simulate link open") { session.signIn() }
                    .buttonStyle(PrimaryButtonStyle())
            }

            Spacer()
        }
        .padding(24)
        .routeID(.authMagicLinkSent)
        .navigationTitle("Link sent")
    }
}

struct MFAChallengeView: View {
    @EnvironmentObject private var session: AppSession
    @State private var code = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScreenHeader(title: "Two-factor authentication", subtitle: "Enter the 6-digit code from your authenticator app.")

            TextField("123456", text: $code)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .font(.title2.monospacedDigit())

            Button("Verify & continue") {
                session.profile = .demo
                session.finishMFA()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(code.count < 6)

            NavigationLink("Use recovery code instead") {
                MFAChallengeView()
            }
            .font(.subheadline)

            Spacer()
        }
        .padding(24)
        .routeID(.authMFA)
        .navigationTitle("MFA")
    }
}

struct ForgotPasswordView: View {
    @State private var email = ""

    var body: some View {
        Form {
            Section("Reset password") {
                TextField("Work email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            Section {
                NavigationLink("Send reset link") {
                    PasswordResetSentView(email: email)
                }
                .disabled(email.isEmpty)
            }
        }
        .routeID(.authForgotPassword)
        .navigationTitle("Forgot password")
    }
}

struct PasswordResetSentView: View {
    var email: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.rotation")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.brand)
            ScreenHeader(
                title: "Reset link sent",
                subtitle: "If an account exists for \(email.isEmpty ? "that email" : email), you'll get instructions shortly."
            )
            NavigationLink("Back to sign in") { SignInView() }
                .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .padding(24)
        .routeID(.authResetSent)
        .navigationTitle("Reset sent")
    }
}
