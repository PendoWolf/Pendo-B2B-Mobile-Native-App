import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        ZStack {
            AppTheme.heroGradient.ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 84))
                    .foregroundStyle(.white)

                Text("ForgeHub")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Ship code. Drive adoption.")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .routeID(.splash)
        .task {
            try? await Task.sleep(nanoseconds: 1_400_000_000)
            session.finishSplash()
        }
    }
}
