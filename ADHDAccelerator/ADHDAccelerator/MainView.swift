import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskGroup.createdAt) private var allGroups: [TaskGroup]

    @State private var engine = AcceleratorEngine()
    @State private var isShowingEditor = false
    @State private var isCreatingNew = false

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(engine.activeGroup?.title ?? "ADHD Accelerator")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .sheet(isPresented: $isShowingEditor) { editorSheet }
                .onAppear { setupInitialGroup() }
                .onChange(of: allGroups) { _, newValue in
                    if engine.activeGroup == nil {
                        setupInitialGroup()
                    }
                }
        }
    }
}

private extension MainView {
    @ViewBuilder
    var contentView: some View {
        if let group = engine.activeGroup {
            VStack {
                Spacer()
                
                StatsView(
                    group: group,
                    allGroups: allGroups,
                    score: engine.calculateGlobalADHDScore(allGroups: allGroups),
                    engine: engine
                )

                taskArea(for: group)

                Spacer()
            }
        } else {
            EmptyStateCard {
                isCreatingNew = true
                isShowingEditor = true
            }
        }
    }
    
    @ViewBuilder
    func taskArea(for group: TaskGroup) -> some View {
        if let task = engine.currentTask {
            VStack(spacing: 25) {
                SwipeCardView(task: task) { success in
                    engine.handleAction(isComplete: success)
                }
                .id("\(group.id.uuidString)-\(group.currentTaskIndex)")
                .frame(height: 425)

                swipeHints
            }
            .padding()
        } else {
            ContentUnavailableView(
                "No Tasks",
                systemImage: "list.bullet",
                description: Text("Edit this group to add tasks.")
            )
        }
    }

    var swipeHints: some View {
        HStack {
            hintButton(title: "Swipe Left to Skip", icon: "arrow.left.circle", color: .red)
            Spacer()
            hintButton(title: "Swipe Right to Done", icon: "arrow.right.circle", color: .green)
        }
        .padding(.horizontal, 25)
    }

    func hintButton(title: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.caption2).bold()
                .textCase(.uppercase)
        }
        .foregroundColor(color.opacity(0.6))
    }

    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(engine.activeGroup == nil ? "Add Group" : "Edit") {
                isCreatingNew = (engine.activeGroup == nil)
                isShowingEditor = true
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            groupMenu
        }
    }
    
    var groupMenu: some View {
        Menu {
            if !allGroups.isEmpty {
                Section("Switch Group") {
                    ForEach(allGroups) { group in
                        Button(group.title) {
                            withAnimation {
                                engine.activeGroup = group
                            }
                        }
                    }
                }
            }
            Section {
                Button(action: {
                    isCreatingNew = true
                    isShowingEditor = true
                }) {
                    Label("New Group", systemImage: "plus")
                }
            }
        } label: {
            Image(systemName: "rectangle.stack.badge.person.crop")
        }
    }
    
    var editorSheet: some View {
        GroupEditorView(
            group: isCreatingNew ? nil : engine.activeGroup,
            onSave: { newGroup in
                engine.activeGroup = newGroup
                isCreatingNew = false
            },
            onDelete: {
                withAnimation {
                    engine.activeGroup = nil
                }
            }
        )
    }
}

private extension MainView {
    func setupInitialGroup() {
        if let savedID = engine.activeGroupID,
           let savedGroup = allGroups.first(where: { $0.id.uuidString == savedID }) {
            engine.activeGroup = savedGroup
        } else {
            engine.activeGroup = allGroups.first
        }
    }
}

struct EmptyStateCard: View {
    var action: () -> Void
    var body: some View {
        VStack(spacing: 25) {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.secondary, style: StrokeStyle(lineWidth: 2, dash: [8]))
                .frame(height: 425)
                .overlay(
                    VStack(spacing: 15) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 55))
                        Text("No Tasks Yet")
                            .font(.title2).bold()
                        Text("Create a Task Group to start your loop.")
                            .font(.subheadline)
                        Button("Create Now", action: action)
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.white)
                    }
                    .foregroundColor(.secondary)
                )
        }
        .padding(35)
    }
}
