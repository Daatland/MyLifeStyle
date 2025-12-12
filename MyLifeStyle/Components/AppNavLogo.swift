import SwiftUI

struct AppNavLogo: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "figure.run.circle.fill") // midlertidig "logo"
                .font(.system(size: 22, weight: .semibold))
            Text("MyLifeStyle")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("MyLifeStyle")
    }
}
