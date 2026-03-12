import SwiftUI

struct GradientColors: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.red, .purple, .green, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(3/4)
            .ignoresSafeArea()
            
            Text("Colors")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    GradientColors()
}
