import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(FeatureRegistry.allFeatures) { feature in                
                ZStack {
                    NavigationLink(value: feature) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    FeatureCard(feature: feature)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .navigationTitle("SwiftUI Lab")
            .background(Color(.systemGroupedBackground))
            .navigationDestination(for: SwiftFeature.self) { feature in
                DemoWrapper(feature: feature)
            }
        }
    }
}

struct DemoWrapper: View {
    let feature: SwiftFeature
    @State private var showingInfo = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            feature.view
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(feature.toolbarColor)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingInfo = true } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(feature.toolbarColor)
                }
            }
        }
        .sheet(isPresented: $showingInfo) {
            InfoSheet(feature: feature)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ContentView()
}
