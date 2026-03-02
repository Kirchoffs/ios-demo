import SwiftUI
import SwiftData

struct TaskViewItem: Identifiable {
    let id: UUID
    var content: String
    
    init(id: UUID = UUID(), content: String) {
        self.id = id
        self.content = content
    }
}

struct GroupEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var groupTitle: String
    @State private var tasks: [TaskViewItem]
    @State private var newTaskContent: String = ""
    
    var existingGroup: TaskGroup?
    var onSave: ((TaskGroup) -> Void)?
    var onDelete: (() -> Void)?
    
    init(group: TaskGroup? = nil, onSave: ((TaskGroup) -> Void)? = nil, onDelete: (() -> Void)? = nil) {
        self.existingGroup = group
        self.onSave = onSave
        self.onDelete = onDelete
        _groupTitle = State(initialValue: group?.title ?? "")
        let initialTasks = group?.tasks.sorted(by: { $0.order < $1.order }).map { TaskViewItem(id: $0.id, content: $0.content) } ?? []
        _tasks = State(initialValue: initialTasks)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("Enter group name", text: $groupTitle)
                }
                
                Section("Tasks") {
                    ForEach($tasks) { $task in
                        HStack {
                            TextField("Task content", text: $task.content)
                            if tasks.count > 1 {
                                Button(role: .destructive) {
                                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                        tasks.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    .onDelete { tasks.remove(atOffsets: $0) }
                }
                .environment(\.editMode, .constant(.active))
                
                Section {
                    HStack {
                        TextField("New task...", text: $newTaskContent)
                        Button("Add") {
                            if !newTaskContent.isEmpty {
                                tasks.append(TaskViewItem(content: newTaskContent))
                                newTaskContent = ""
                            }
                        }
                        .disabled(newTaskContent.isEmpty)
                    }
                }
                
                if existingGroup != nil {
                    Section {
                        Button("Delete This Group", role: .destructive) {
                            deleteGroup()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(existingGroup == nil ? "New Group" : "Edit Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveGroup() }
                        .disabled(isSaveDisabled)
                }
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        groupTitle.isEmpty || tasks.isEmpty || tasks.contains(where: { $0.content.trimmingCharacters(in: .whitespaces).isEmpty })
    }
    
    private func saveGroup() {
        let groupToReturn: TaskGroup
        
        if let group = existingGroup {
            let sortedOldTasks = group.tasks.sorted(by: { $0.order < $1.order })
            let currentTaskID = (group.currentTaskIndex < sortedOldTasks.count) ? sortedOldTasks[group.currentTaskIndex].id : nil
            
            group.title = groupTitle
            for task in group.tasks {
                modelContext.delete(task)
            }
            group.tasks.removeAll()
            
            var newCurrentIndex = 0
            for (index, task) in tasks.enumerated() {
                let item = TaskItem(content: task.content, order: index)
                item.id = task.id
                modelContext.insert(item)
                group.tasks.append(item)
                
                if let currentID = currentTaskID, item.id == currentID {
                    newCurrentIndex = index
                }
            }
            
            if currentTaskID != nil && !tasks.contains(where: { $0.id == currentTaskID }) {
                newCurrentIndex = min(group.currentTaskIndex, tasks.count - 1)
            }
            
            group.currentTaskIndex = max(0, newCurrentIndex)
            groupToReturn = group
        } else {
            let newGroup = TaskGroup(title: groupTitle)
            modelContext.insert(newGroup)
            
            for (index, task) in tasks.enumerated() {
                let item = TaskItem(content: task.content, order: index)
                item.id = task.id
                modelContext.insert(item)
                newGroup.tasks.append(item)
            }
            groupToReturn = newGroup
        }
        
        try? modelContext.save()
        onSave?(groupToReturn)
        dismiss()
    }
    
    private func deleteGroup() {
        if let group = existingGroup {
            onDelete?()
            modelContext.delete(group)
            dismiss()
        }
    }
}
