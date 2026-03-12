import SwiftUI

struct ShapeDemoView: View {
    var body: some View {
        VStack(spacing: 32) {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 256, height: 128)
                .shadow(radius: 12)
            
            Circle()
                .strokeBorder(Color.orange, lineWidth: 8)
                .frame(width: 128, height: 128)
        }
    }
}

#Preview {
    ShapeDemoView()
}
