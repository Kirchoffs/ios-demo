import SwiftUI
import SwiftData

@Observable
@MainActor
class AcceleratorEngine {
    var activeGroup: TaskGroup? {
        didSet {
            if let group = activeGroup {
                activeGroupID = group.id.uuidString
                if group.currentLoopStartTime == nil {
                    startTiming()
                }
            }
        }
    }
    
    private let activeGroupKey = "lastActiveGroupID"
    private let numRecentTasks = 15
    private let numRecentLoops = 15
    private let decayFactor = 0.99
    private let taskScaleFactor = Double(1 << 12)
    private let loopScaleFactor = Double(1 << 14)
    
    private let minStandardTaskTime: TimeInterval = Double(1 << 9)
    private let maxStandardTaskTime: TimeInterval = Double(1 << 18)
    
    var activeGroupID: String? {
        get { UserDefaults.standard.string(forKey: activeGroupKey) }
        set { UserDefaults.standard.set(newValue, forKey: activeGroupKey) }
    }
    
    func resetIndex() {
        activeGroup?.currentTaskIndex = 0
        activeGroup?.currentLoopStartTime = nil
        activeGroup?.currentTaskStartTime = nil
    }
    
    var currentTask: TaskItem? {
        guard let group = activeGroup
        else {
            return nil
        }
        
        let sortedTasks = group.tasks.sorted(by: { $0.order < $1.order })
        guard !sortedTasks.isEmpty else { return nil }
        
        let safeIndex = max(0, min(group.currentTaskIndex, sortedTasks.count - 1))
        return sortedTasks[safeIndex]
    }
    
    func startTiming() {
        guard let group = activeGroup 
        else { return }

        if group.currentLoopStartTime == nil { group.currentLoopStartTime = Date() }
        if group.currentTaskStartTime == nil { group.currentTaskStartTime = Date() }
    }
    
    func handleAction(isComplete: Bool) {
        guard let group = activeGroup
        else {
            return
        }
        
        if isComplete {
            completeTask(group: group)
        } else {
            skipTask(group: group)
        }
    }
    
    private func completeTask(group: TaskGroup) {
        let tasksCount = group.tasks.count
        guard tasksCount > 0 else { return }
        
        if let taskStart = group.currentTaskStartTime {
            var duration = Date().timeIntervalSince(taskStart)
            duration = min(duration, maxStandardTaskTime)
            
            group.totalTasksCount += 1
            group.totalElapsedTime += duration
            
            group.recentTaskTimes.append(duration)
            if group.recentTaskTimes.count > numRecentTasks {
                group.recentTaskTimes.removeFirst()
            }
            
            if group.minTaskTime == nil || duration < group.minTaskTime! {
                group.minTaskTime = duration
            }
            if group.maxTaskTime == nil || duration > group.maxTaskTime! {
                group.maxTaskTime = duration
            }
        }
        
        advanceTask(group: group)
        
        updateGroupScore(group: group)
    }
    
    private func skipTask(group: TaskGroup) {
        advanceTask(group: group)
    }
    
    private func advanceTask(group: TaskGroup) {
        let tasksCount = group.tasks.count
        guard tasksCount > 0 else { return }
        
        if group.currentTaskIndex < tasksCount - 1 {
            group.currentTaskIndex += 1
            group.currentTaskStartTime = Date()
        } else {
            finishLoop(group: group)
            group.currentTaskIndex = 0
            group.currentTaskStartTime = Date()
        }
    }
    
    private func finishLoop(group: TaskGroup) {
        guard let start = group.currentLoopStartTime
        else {
            return
        }
        
        var duration = Date().timeIntervalSince(start)
        let maxStandardLoopTime = maxStandardTaskTime * Double(group.tasks.count)
        duration = min(duration, maxStandardLoopTime)
        
        group.totalLoopsCount += 1
        
        group.recentLoopTimes.append(duration)
        if group.recentLoopTimes.count > numRecentLoops {
            group.recentLoopTimes.removeFirst()
        }
        
        if group.minLoopTime == nil || duration < group.minLoopTime! {
            group.minLoopTime = duration
        }
        if group.maxLoopTime == nil || duration > group.maxLoopTime! {
            group.maxLoopTime = duration
        }
        
        group.currentLoopStartTime = Date()
    }
    
    func updateGroupScore(group: TaskGroup) {
        let contribution = calculateGroupContribution(for: group)
        let newScore = (decayFactor * group.currentScore) + contribution
        
        group.currentScore = newScore.isFinite ? newScore : group.currentScore
    }
    
    func calculateGroupContribution(for group: TaskGroup) -> Double {
        var contribution: Double = 0
        
        if !group.recentTaskTimes.isEmpty {
            let recentMinTaskTime = group.recentTaskTimes.min()!
            let coeffOfTask = min(1.0, recentMinTaskTime / minStandardTaskTime) * taskScaleFactor
            let recentSumTaskTime = group.recentTaskTimes.reduce(0, +)
            if recentSumTaskTime > 0 {
                contribution += coeffOfTask * Double(group.recentTaskTimes.count) / recentSumTaskTime
            }
        }
        
        let minStandardLoopTime = minStandardTaskTime * Double(group.tasks.count)
        if !group.recentLoopTimes.isEmpty {
            let recentMinLoopTime = group.recentLoopTimes.min()!
            let coeffOfLoop = min(1.0, recentMinLoopTime / minStandardLoopTime) * loopScaleFactor
            let recentSumLoopTime = group.recentLoopTimes.reduce(0, +)
            if recentSumLoopTime > 0 {
                contribution += coeffOfLoop * Double(group.recentLoopTimes.count) / recentSumLoopTime
            }
        }
        
        return contribution
    }
    
    func calculateGlobalADHDScore(allGroups: [TaskGroup]) -> Double {
        return allGroups.reduce(0) { $0 + $1.currentScore }
    }
    
    func calculateADHDScore(for group: TaskGroup) -> Double {
        return group.currentScore
    }
}
