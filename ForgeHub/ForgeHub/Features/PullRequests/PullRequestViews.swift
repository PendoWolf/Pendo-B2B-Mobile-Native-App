import SwiftUI

struct PullRequestListView: View {
    @EnvironmentObject private var session: AppSession
    var repoName: String? = nil

    private var items: [PullRequest] {
        guard let repoName else { return session.pullRequests }
        return session.pullRequests.filter { $0.repoName == repoName }
    }

    var body: some View {
        List {
            Section {
                NavigationLink("New pull request") {
                    CreatePullRequestView(repoName: repoName ?? "platform-api")
                }
            }
            Section(repoName ?? "All pull requests") {
                ForEach(items) { pr in
                    NavigationLink {
                        PullRequestDetailView(pr: pr)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("#\(pr.number) \(pr.title)")
                                .font(.subheadline.weight(.semibold))
                            Text("\(pr.author) · \(pr.repoName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .routeID(.prList)
        .navigationTitle("Pull requests")
    }
}

struct PullRequestDetailView: View {
    let pr: PullRequest

    var body: some View {
        List {
            Section {
                Text(pr.title).font(.headline)
                Text("Opened by \(pr.author)")
                    .foregroundStyle(.secondary)
                HStack {
                    StatusChip(text: pr.status.rawValue)
                    Text("+\(pr.additions)/-\(pr.deletions)")
                        .font(.caption.monospacedDigit())
                }
            }
            Section("Reviewers") {
                ForEach(pr.reviewers, id: \.self) { reviewer in
                    Label(reviewer, systemImage: "person.circle")
                }
            }
            Section("Actions") {
                NavigationLink("Submit review") { PRReviewView(pr: pr) }
                NavigationLink("View checks") { PRChecksView(pr: pr) }
                NavigationLink("Merge pull request") { PRMergeView(pr: pr) }
            }
        }
        .routeID(.prDetail)
        .navigationTitle("#\(pr.number)")
    }
}

struct PRReviewView: View {
    let pr: PullRequest
    @State private var verdict = "Approve"
    @State private var comment = ""

    var body: some View {
        Form {
            Section("Review for #\(pr.number)") {
                Picker("Verdict", selection: $verdict) {
                    Text("Approve").tag("Approve")
                    Text("Comment").tag("Comment")
                    Text("Request changes").tag("Request changes")
                }
                TextField("Leave a comment", text: $comment, axis: .vertical)
                    .lineLimit(3...6)
            }
            Section {
                NavigationLink("Submit review") {
                    PullRequestDetailView(pr: pr)
                }
            }
        }
        .routeID(.prReview)
        .navigationTitle("Review")
    }
}

struct PRChecksView: View {
    let pr: PullRequest

    var body: some View {
        List {
            Label(pr.checksPassing ? "CI / build — passed" : "CI / build — failing", systemImage: pr.checksPassing ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(pr.checksPassing ? AppTheme.success : AppTheme.danger)
            Label("Lint — passed", systemImage: "checkmark.circle.fill")
                .foregroundStyle(AppTheme.success)
            Label("Security scan — passed", systemImage: "checkmark.circle.fill")
                .foregroundStyle(AppTheme.success)
            if !pr.checksPassing {
                NavigationLink("View failing logs") {
                    ActivityDetailView(title: "CI failure", bodyText: "Unit test MobileOnboardingTests failed on iOS 17.2 simulator.")
                }
            }
        }
        .routeID(.prChecks)
        .navigationTitle("Checks")
    }
}

struct PRMergeView: View {
    let pr: PullRequest
    @State private var strategy = "Squash and merge"

    var body: some View {
        Form {
            Section("Merge #\(pr.number)") {
                Picker("Strategy", selection: $strategy) {
                    Text("Create a merge commit").tag("Create a merge commit")
                    Text("Squash and merge").tag("Squash and merge")
                    Text("Rebase and merge").tag("Rebase and merge")
                }
                if !pr.checksPassing {
                    Text("Checks are failing. Merge may be blocked.")
                        .foregroundStyle(AppTheme.danger)
                }
            }
            Section {
                NavigationLink("Confirm merge") {
                    ActivityDetailView(title: "Merged", bodyText: "Pull request #\(pr.number) was merged with \(strategy).")
                }
                .disabled(!pr.checksPassing && pr.status != .approved)
            }
        }
        .routeID(.prMerge)
        .navigationTitle("Merge")
    }
}

struct CreatePullRequestView: View {
    let repoName: String
    @State private var title = ""
    @State private var bodyText = ""
    @State private var base = "main"
    @State private var compare = "feature/my-branch"

    var body: some View {
        Form {
            Section("\(repoName)") {
                TextField("Title", text: $title)
                TextField("Description", text: $bodyText, axis: .vertical)
                    .lineLimit(4...8)
                Picker("Base", selection: $base) {
                    Text("main").tag("main")
                    Text("develop").tag("develop")
                }
                TextField("Compare branch", text: $compare)
            }
            Section {
                NavigationLink("Create pull request") {
                    PullRequestDetailView(
                        pr: PullRequest(
                            id: "pr_new",
                            number: 999,
                            title: title.isEmpty ? "Untitled PR" : title,
                            author: "you",
                            repoName: repoName,
                            status: .open,
                            reviewers: [],
                            checksPassing: true,
                            additions: 10,
                            deletions: 2
                        )
                    )
                }
                .disabled(title.isEmpty)
            }
        }
        .routeID(.prCreate)
        .navigationTitle("New PR")
    }
}
