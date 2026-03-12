import SwiftUI

struct FeatureCard: View {
    let feature: SwiftFeature
    
    var body: some View {
        HStack {
            Label {
                VStack(alignment: .leading) {
                    Text(feature.title).font(.headline)
                    Text("SwiftUI Basics").font(.caption).foregroundColor(.secondary)
                }
            } icon: {
                Image(systemName: feature.icon)
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(feature.color)
                    .cornerRadius(12)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct InfoSheet: View {
    let feature: SwiftFeature
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Image(systemName: feature.icon)
                        .font(.system(size: 64))
                        .foregroundColor(feature.color)
                    
                    Text(feature.description)
                        .font(.body)
                        .lineSpacing(8)
                        .padding()
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(feature.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
