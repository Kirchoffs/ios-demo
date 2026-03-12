import SwiftUI

struct GradientColorsWithTapGesture: View {
    private let colorGroupAlpha: [Color] = [.black, .white, .blue]
    private let colorGroupBeta: [Color] = [.red, .purple, .green, .pink]
    
    @State private var screenTapped: Bool = false
    @State private var offsetY: CGFloat = -512
    
    var colors: [Color] {
        screenTapped ? colorGroupBeta : colorGroupAlpha
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(3/4)
            .ignoresSafeArea()
            
            Text("Colors")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .offset(y: offsetY)
        }.onTapGesture {
            screenTapped.toggle()
            withAnimation(.easeIn(duration: 1/2)) {
                offsetY = screenTapped ? 4 : -512
            }
        }
    }
}

#Preview {
    GradientColors()
}
