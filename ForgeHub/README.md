# ForgeHub

Native iOS (SwiftUI) B2B marketing-tech app for encouraging adoption of a GitHub-style code collaboration product.

Built with **many branching user journeys** so route-scanning / path-discovery tooling can exercise a rich navigation graph.

## Open & run

```bash
cd ForgeHub
xcodegen generate
open ForgeHub.xcodeproj
```

Select an iOS Simulator and press Run (`⌘R`).

Minimum: **iOS 17+**.

## Product concept

**ForgeHub** is an enterprise repo + PR platform with an embedded adoption suite:

- Feature adoption scoring
- Playbooks
- Multi-channel campaigns (in-app / email / Slack)
- Segments & nudges
- Integrations, billing upgrade, team invites

## Entry flows (branching)

From **Welcome**, users can take three top-level paths:

1. **Get started** → role → company size → goals → auth method → create/join org → invite team (optional) → first repo (create / import / skip) → complete
2. **Sign in** → password (± MFA) **or** SSO **or** OAuth **or** magic link **or** forgot password
3. **Explore demo workspace** → jumps straight into the main tabs with sample data

## Main tabs

| Tab | Purpose |
|-----|---------|
| Home | Metrics, quick start, PR attention, feature spotlight, upgrade wall |
| Repos | List / search / filters / detail / branches / files / commits / settings / create / import |
| Adoption | Metrics, features, segments, playbooks, nudges |
| Campaigns | List + 6-step create wizard + detail / analytics / A/B |
| More | Profile, team, billing, integrations, settings, route catalog |

## Route scanning helpers

- Every screen sets `accessibilityIdentifier = route.<routeName>`
- `AppRoute` enum enumerates **80+** named routes
- Welcome → **See all scannable routes** opens the in-app route catalog
- About screen shows the live route count

## Suggested paths to exercise

1. Welcome → Get started → Email signup → Create org → Skip invites → Skip repo → Enter app
2. Welcome → Sign in → MFA → Home → Campaigns → Create campaign (full wizard)
3. Welcome → Demo → Repos → Repo detail → PR → Review → Checks → Merge
4. Demo → Adoption → Playbook → Activate → also create campaign
5. More → Billing → Growth → Checkout → Success
6. More → Integrations → Connect → Configure → Success
7. Home upgrade banner → Upgrade wall → Plans
