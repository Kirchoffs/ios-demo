import SwiftUI

struct TextDemoView: View {
    @State private var screenTapped: Bool = false
    
    var text: String {
        screenTapped ?
            """
            The most important conversation you will ever have is with yourself.
            """ :
            "SwiftUI Basics"
    }
    
    let rotationAngle: CGFloat = 360
    
    var body: some View {
        VStack(spacing: 24) {
            Text(text)
                .font(screenTapped ? .system(size: 24, weight: .black) : .system(size: 36, weight: .black, design: .rounded))
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(screenTapped ? .blue : .black)
            .rotation3DEffect(.degrees(screenTapped ? 0 : rotationAngle), axis: (x: 0, y: 1, z: 0))
            
            if !screenTapped {
                Text("Building beautiful UIs with declarative code.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.25)) {
                screenTapped.toggle()
            }
        }
    }
}

#Preview {
    TextDemoView()
}
