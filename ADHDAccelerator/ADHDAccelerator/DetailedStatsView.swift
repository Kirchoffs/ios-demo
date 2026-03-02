import SwiftUI

struct DetailedStatsView: View {
    let currentGroup: TaskGroup
    let allGroups: [TaskGroup]
    let engine: AcceleratorEngine
    
    var body: some View {
        List {
            groupSection
            globalSection
        }
        .navigationTitle("Performance Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension DetailedStatsView {
    var groupSection: some View {
        Section("Current Group: \(currentGroup.title)") {
            detailRow(
                label: "ADHD Score",
                value: String(format: "%.2f", engine.calculateADHDScore(for: currentGroup))
            )
            detailRow(label: "Total Loops Done", value: "\(currentGroup.totalLoopsCount)")
            detailRow(label: "Total Tasks Done", value: "\(currentGroup.totalTasksCount)")
            detailRow(label: "Total Time", value: formatDuration(currentGroup.totalElapsedTime))
            
            Group {
                timeRow(label: "Fastest Loop", seconds: currentGroup.minLoopTime)
                timeRow(label: "Slowest Loop", seconds: currentGroup.maxLoopTime)
                timeRow(label: "Fastest Task", seconds: currentGroup.minTaskTime)
                timeRow(label: "Slowest Task", seconds: currentGroup.maxTaskTime)
            }
        }
    }
    
    var globalSection: some View {
        Section("Global Statistics") {
            detailRow(label: "ADHD Score", value: String(format: "%.2f", engine.calculateGlobalADHDScore(allGroups: allGroups)))
            detailRow(label: "Total Groups", value: "\(allGroups.count)")

            
            let globalTotals = calculateGlobalTotals()
            detailRow(label: "Total Loops Done", value: "\(globalTotals.loops)")
            detailRow(label: "Total Tasks Done", value: "\(globalTotals.tasks)")
        }
    }
    
    func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).bold().foregroundColor(.secondary)
        }
    }
    
    func timeRow(label: String, seconds: TimeInterval?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(seconds != nil ? formatDuration(seconds!) : "--")
                .bold()
                .foregroundColor(.primary)
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration)!
    }
    
    func calculateGlobalTotals() -> (loops: Int, tasks: Int) {
        var loops = 0
        var tasks = 0
        
        for group in allGroups {
            loops += group.totalLoopsCount
            tasks += group.totalTasksCount
        }
        
        return (loops, tasks)
    }
}
