# Pendo B2B Mobile Native App

SwiftUI iOS app (**ForgeHub**) for testing multi-path user route discovery on a GitHub-style B2B adoption product.

## Open & run

```bash
cd ForgeHub
xcodegen generate   # if project needs regenerating
open ForgeHub.xcodeproj
```

Requires **Xcode** and **iOS 17+**.

## What's included

- Branching auth & onboarding (email, SSO, OAuth, magic link, MFA)
- Main tabs: Home, Repos, Adoption, Campaigns, More
- Campaign wizard, playbooks, billing upgrade, integrations
- **99 named routes** with `accessibilityIdentifier` markers for path scanning

See [`ForgeHub/README.md`](ForgeHub/README.md) for full flow documentation.
