import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID = UUID()
    var content: String
    var order: Int
    var note: String = ""
    
    init(content: String, order: Int) {
        self.content = content
        self.order = order
    }
}

@Model
final class TaskGroup {
    var id: UUID = UUID()
    var title: String
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade)
    var tasks: [TaskItem] = []
    
    var currentTaskIndex: Int = 0
    
    var currentLoopStartTime: Date? = nil
    var currentTaskStartTime: Date? = nil

    var totalLoopsCount: Int = 0
    var minLoopTime: TimeInterval? = nil
    var maxLoopTime: TimeInterval? = nil

    var totalTasksCount: Int = 0
    var minTaskTime: TimeInterval? = nil
    var maxTaskTime: TimeInterval? = nil

    var totalElapsedTime: TimeInterval = 0
    
    var recentTaskTimes: [TimeInterval] = []
    var recentLoopTimes: [TimeInterval] = []
    
    var currentScore: Double = 0
    
    init(title: String) {
        self.title = title
    }
}
