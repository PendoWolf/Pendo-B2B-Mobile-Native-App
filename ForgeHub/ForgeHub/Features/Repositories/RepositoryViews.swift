import SwiftUI

struct RepositoryListView: View {
    @EnvironmentObject private var session: AppSession
    @State private var query = ""

    private var filtered: [Repository] {
        guard !query.isEmpty else { return session.repositories }
        return session.repositories.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.language.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List {
            Section {
                NavigationLink("Search repositories") { RepositorySearchView() }
                NavigationLink("Filters") { RepositoryFiltersView() }
                NavigationLink("Create repository") { CreateRepositoryView() }
                NavigationLink("Import repository") { ImportRepositoryView() }
            }

            if filtered.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "externaldrive.badge.plus")
                            .font(.largeTitle)
                            .foregroundStyle(AppTheme.brand)
                        Text("No matching repositories")
                            .font(.headline)
                        Text("Create or import a repo to start measuring adoption.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .accessibilityIdentifier("route.repoEmptyState")
                }
            } else {
                Section("Your repositories") {
                    ForEach(filtered) { repo in
                        NavigationLink {
                            RepositoryDetailView(repo: repo)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(repo.name).font(.headline)
                                    if repo.isPrivate {
                                        Image(systemName: "lock.fill").font(.caption2).foregroundStyle(.secondary)
                                    }
                                }
                                Text(repo.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Text(repo.language)
                                    Text("★ \(repo.stars)")
                                    Text("\(repo.openPRs) open PRs")
                                    Spacer()
                                    Text("Adopt \(repo.adoptionScore)%")
                                        .foregroundStyle(AppTheme.accent)
                                }
                                .font(.caption2)
                            }
                            .padding(.vertical, 4)
                        }
                        .accessibilityIdentifier("repo.\(repo.id)")
                    }
                }
            }
        }
        .routeID(.repositories)
        .navigationTitle("Repositories")
        .searchable(text: $query, prompt: "Filter repos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink { CreateRepositoryView() } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct RepositorySearchView: View {
    @EnvironmentObject private var session: AppSession
    @State private var query = ""

    var body: some View {
        List(session.repositories.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }) { repo in
            NavigationLink(repo.name) { RepositoryDetailView(repo: repo) }
        }
        .searchable(text: $query)
        .routeID(.repoSearch)
        .navigationTitle("Search")
    }
}

struct RepositoryFiltersView: View {
    @State private var onlyPrivate = false
    @State private var language = "Any"
    @State private var minAdoption = 0.0

    var body: some View {
        Form {
            Toggle("Private only", isOn: $onlyPrivate)
            Picker("Language", selection: $language) {
                ForEach(["Any", "Swift", "Go", "TypeScript", "HCL", "MDX"], id: \.self) { Text($0) }
            }
            VStack(alignment: .leading) {
                Text("Min adoption: \(Int(minAdoption))%")
                Slider(value: $minAdoption, in: 0...100, step: 5)
            }
            Section {
                NavigationLink("Apply filters") { RepositoryListView() }
            }
        }
        .routeID(.repoFilters)
        .navigationTitle("Filters")
    }
}

struct RepositoryDetailView: View {
    let repo: Repository

    var body: some View {
        List {
            Section {
                Text(repo.description)
                HStack {
                    StatusChip(text: repo.isPrivate ? "Private" : "Public")
                    StatusChip(text: repo.language, color: AppTheme.accent)
                    StatusChip(text: "Adoption \(repo.adoptionScore)%", color: AppTheme.success)
                }
            }
            Section("Explore") {
                NavigationLink("Branches") { RepoBranchesView(repo: repo) }
                NavigationLink("Files") { RepoFilesView(repo: repo) }
                NavigationLink("Commits") { RepoCommitsView(repo: repo) }
                NavigationLink("Pull requests") { PullRequestListView(repoName: repo.name) }
                NavigationLink("Settings") { RepoSettingsView(repo: repo) }
            }
            Section("Adoption") {
                NavigationLink("Improve adoption for this repo") {
                    FeatureAdoptionDetailView(feature: SampleData.features[2])
                }
            }
        }
        .routeID(.repoDetail)
        .navigationTitle(repo.name)
    }
}

struct CreateRepositoryView: View {
    @EnvironmentObject private var session: AppSession
    var completesOnboarding: Bool = false
    @State private var name = ""
    @State private var description = ""
    @State private var isPrivate = true
    @State private var template = "Empty"

    var body: some View {
        Form {
            Section("Repository") {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                Toggle("Private", isOn: $isPrivate)
                Picker("Template", selection: $template) {
                    ForEach(["Empty", "API service", "iOS app", "Docs site"], id: \.self) { Text($0) }
                }
            }
            Section {
                NavigationLink("Create repository") {
                    RepoCreateSuccessView(name: name.isEmpty ? "new-repo" : name, completesOnboarding: completesOnboarding)
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .routeID(.repoCreate)
        .navigationTitle("New repository")
    }
}

struct RepoCreateSuccessView: View {
    @EnvironmentObject private var session: AppSession
    let name: String
    var completesOnboarding: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.success)
            ScreenHeader(title: "\(name) created", subtitle: "Your repository is ready. Invite collaborators or open the first PR.")

            if completesOnboarding {
                NavigationLink("Continue setup") { OnboardingCompleteView() }
                    .buttonStyle(PrimaryButtonStyle())
            } else {
                Button("Go to repositories") { session.selectedTab = .repositories }
                    .buttonStyle(PrimaryButtonStyle())
                NavigationLink("Create pull request") {
                    CreatePullRequestView(repoName: name)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            Spacer()
        }
        .padding(24)
        .routeID(.repoCreateSuccess)
        .navigationTitle("Success")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            let repo = Repository(
                id: "repo_\(UUID().uuidString.prefix(5))",
                name: name,
                description: "Newly created repository",
                language: "Swift",
                stars: 0,
                forks: 0,
                isPrivate: true,
                openPRs: 0,
                adoptionScore: 10,
                lastUpdated: "Just now"
            )
            if !session.repositories.contains(where: { $0.name == name }) {
                session.repositories.insert(repo, at: 0)
            }
        }
    }
}

struct ImportRepositoryView: View {
    var completesOnboarding: Bool = false
    @State private var url = ""
    @State private var provider = "GitHub"

    var body: some View {
        Form {
            Section("Import from") {
                Picker("Provider", selection: $provider) {
                    ForEach(["GitHub", "GitLab", "Bitbucket", "URL"], id: \.self) { Text($0) }
                }
                TextField("Repository URL", text: $url)
                    .textInputAutocapitalization(.never)
            }
            Section {
                if completesOnboarding {
                    NavigationLink("Import") { OnboardingCompleteView() }
                        .disabled(url.isEmpty)
                } else {
                    NavigationLink("Import") {
                        RepoCreateSuccessView(name: "imported-repo")
                    }
                    .disabled(url.isEmpty)
                }
            }
        }
        .routeID(.repoImport)
        .navigationTitle("Import")
    }
}

struct RepoBranchesView: View {
    let repo: Repository
    private let branches = ["main", "develop", "feature/adoption-nudges", "hotfix/login-crash"]

    var body: some View {
        List(branches, id: \.self) { branch in
            Label(branch, systemImage: branch == "main" ? "star.fill" : "arrow.triangle.branch")
        }
        .routeID(.repoBranches)
        .navigationTitle("Branches")
    }
}

struct RepoFilesView: View {
    let repo: Repository
    private let files = ["README.md", "Package.swift", "Sources/", "Tests/", "CODEOWNERS", ".github/workflows/ci.yml"]

    var body: some View {
        List(files, id: \.self) { file in
            Label(file, systemImage: file.hasSuffix("/") ? "folder.fill" : "doc.text")
        }
        .routeID(.repoFiles)
        .navigationTitle("Files")
    }
}

struct RepoCommitsView: View {
    let repo: Repository

    var body: some View {
        List {
            ForEach([
                ("a1b2c3d", "Improve onboarding empty states", "morgan.k", "2h ago"),
                ("e4f5g6h", "Add campaign analytics chart", "sam.lee", "Yesterday"),
                ("i7j8k9l", "Wire SSO domain lookup", "alex", "3d ago")
            ], id: \.0) { commit in
                VStack(alignment: .leading, spacing: 4) {
                    Text(commit.1).font(.subheadline.weight(.semibold))
                    Text("\(commit.0) · \(commit.2) · \(commit.3)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .routeID(.repoCommits)
        .navigationTitle("Commits")
    }
}

struct RepoSettingsView: View {
    let repo: Repository
    @State private var defaultBranch = "main"
    @State private var requireReviews = true

    var body: some View {
        Form {
            Section("General") {
                Text(repo.name)
                Picker("Default branch", selection: $defaultBranch) {
                    Text("main").tag("main")
                    Text("develop").tag("develop")
                }
            }
            Section("Protection") {
                Toggle("Require pull request reviews", isOn: $requireReviews)
                Toggle("Require status checks", isOn: .constant(true))
            }
            Section("Danger zone") {
                Button("Transfer repository", role: .destructive) {}
                Button("Delete repository", role: .destructive) {}
            }
        }
        .routeID(.repoSettings)
        .navigationTitle("Settings")
    }
}
