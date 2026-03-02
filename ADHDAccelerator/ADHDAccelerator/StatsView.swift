import SwiftUI

import SwiftUI

struct StatsView: View {
    let group: TaskGroup
    let allGroups: [TaskGroup]
    let score: Double
    let engine: AcceleratorEngine

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("ADHD Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "%.2f", score))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                NavigationLink(destination: DetailedStatsView(
                    currentGroup: group,
                    allGroups: allGroups,
                    engine: engine
                )) {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Details")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(18)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(16)
            
            HStack(spacing: 12) {
                statCard(title: "Loops", value: "\(group.totalLoopsCount)", color: .blue)
                statCard(title: "Tasks", value: "\(group.totalTasksCount)", color: .green)
            }
        }
        .padding(.horizontal)
    }

    func statCard(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .frame(height: 65)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

