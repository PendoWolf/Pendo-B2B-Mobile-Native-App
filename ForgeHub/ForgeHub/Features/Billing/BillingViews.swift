import SwiftUI

struct BillingPlansView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        List {
            Section("Current plan") {
                Text(session.profile?.plan.rawValue ?? "Free")
                    .font(.headline)
            }
            Section("Available plans") {
                ForEach(BillingPlan.allCases) { plan in
                    NavigationLink {
                        BillingUpgradeView(plan: plan)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(plan.rawValue).font(.headline)
                                Spacer()
                                Text(plan.priceLabel).foregroundStyle(AppTheme.brand)
                            }
                            ForEach(plan.features, id: \.self) { feature in
                                Text("• \(feature)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            Section {
                NavigationLink("Invoices") { BillingInvoicesView() }
            }
        }
        .routeID(.billingPlans)
        .navigationTitle("Billing")
    }
}

struct BillingUpgradeView: View {
    let plan: BillingPlan

    var body: some View {
        List {
            Section("Upgrade to \(plan.rawValue)") {
                Text(plan.priceLabel).font(.title.bold())
                ForEach(plan.features, id: \.self) { feature in
                    Label(feature, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.success)
                }
            }
            Section {
                NavigationLink("Continue to checkout") {
                    BillingCheckoutView(plan: plan)
                }
            }
        }
        .routeID(.billingUpgrade)
        .navigationTitle(plan.rawValue)
    }
}

struct BillingCheckoutView: View {
    let plan: BillingPlan
    @State private var seats = 25
    @State private var card = "•••• 4242"

    var body: some View {
        Form {
            Section("Checkout") {
                Stepper("Seats: \(seats)", value: $seats, in: 5...500)
                TextField("Payment method", text: $card)
                LabeledContent("Due today", value: estimate)
            }
            Section {
                NavigationLink("Confirm purchase") {
                    BillingSuccessView(plan: plan)
                }
            }
        }
        .routeID(.billingCheckout)
        .navigationTitle("Checkout")
    }

    private var estimate: String {
        switch plan {
        case .free: return "$0"
        case .growth: return "$\(seats * 12)"
        case .enterprise: return "Talk to sales"
        }
    }
}

struct BillingSuccessView: View {
    @EnvironmentObject private var session: AppSession
    let plan: BillingPlan

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.success)
            ScreenHeader(
                title: "You're on \(plan.rawValue)",
                subtitle: "Campaigns, playbooks, and advanced segments are unlocked."
            )
            Button("Back to workspace") {
                session.upgrade(to: plan)
                session.selectedTab = .home
            }
            .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .padding(24)
        .routeID(.billingSuccess)
        .navigationTitle("Success")
        .navigationBarBackButtonHidden(true)
        .onAppear { session.upgrade(to: plan) }
    }
}

struct BillingInvoicesView: View {
    private let invoices = [
        ("INV-2041", "Jun 2026", "$300"),
        ("INV-1988", "May 2026", "$300"),
        ("INV-1902", "Apr 2026", "$276")
    ]

    var body: some View {
        List(invoices, id: \.0) { inv in
            HStack {
                VStack(alignment: .leading) {
                    Text(inv.0).font(.headline)
                    Text(inv.1).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text(inv.2)
            }
        }
        .routeID(.billingInvoices)
        .navigationTitle("Invoices")
    }
}

struct UpgradeWallView: View {
    @EnvironmentObject private var session: AppSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScreenHeader(
                title: "Grow adoption faster",
                subtitle: "Growth unlocks multi-channel campaigns, playbooks, and segment targeting."
            )

            ForEach(BillingPlan.growth.features, id: \.self) { feature in
                Label(feature, systemImage: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.brand)
            }

            NavigationLink("See plans") {
                BillingPlansView()
            }
            .buttonStyle(PrimaryButtonStyle())

            Button("Not now") {
                session.showUpgradeWall = false
                dismiss()
            }
            .buttonStyle(GhostButtonStyle())
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding(24)
        .routeID(.upgradeWall)
        .navigationTitle("Upgrade")
        .navigationBarTitleDisplayMode(.inline)
    }
}
