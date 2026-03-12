import SwiftUI

struct StateDemoView: View {
    @State private var toggleStatus = false
    
    var body: some View {
        VStack(spacing: 48) {
            Circle()
                .frame(width: 128, height: 128)
                .foregroundColor(toggleStatus ? .green : .cyan)
                .overlay(Text(toggleStatus ? "ON" : "OFF").bold())
            
            Toggle("Light Switch", isOn: $toggleStatus)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()
        }
    }
}

#Preview {
    StateDemoView()
}
