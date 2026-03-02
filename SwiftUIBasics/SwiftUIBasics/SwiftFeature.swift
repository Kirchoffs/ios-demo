import SwiftUI

struct SwiftFeature: Identifiable, Hashable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
    let view: AnyView
    let toolbarColor: Color
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SwiftFeature, rhs: SwiftFeature) -> Bool {
        lhs.id == rhs.id
    }
    
    init(
        title: String,
        icon: String,
        color: Color,
        description: String,
        view: AnyView,
        toolbarColor: Color = .blue
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.description = description
        self.view = view
        self.toolbarColor = toolbarColor
    }
}

struct FeatureRegistry {
    static let allFeatures: [SwiftFeature] = [
        SwiftFeature(
            title: "Text & Typography",
            icon: "textformat",
            color: .blue,
            description: "Learn how to customize text fonts, weights, and multi-line behavior in SwiftUI.",
            view: AnyView(TextDemoView())
        ),
        SwiftFeature(
            title: "Shapes & Colors",
            icon: "paintpalette.fill",
            color: .orange,
            description: "Explore geometric shapes, strokes, and beautiful gradients.",
            view: AnyView(ShapeDemoView())
        ),
        SwiftFeature(
            title: "State & Interaction",
            icon: "hand.tap.fill",
            color: .green,
            description: "See how @State updates the UI automatically when data changes.",
            view: AnyView(StateDemoView())
        ),
        SwiftFeature(
            title: "Gradient Colors",
            icon: "line.3.crossed.swirl.circle.fill",
            color: .yellow,
            description: "A background with a color gradient",
            view: AnyView(GradientColors()),
            toolbarColor: .white
        ),
        SwiftFeature(
            title: "Gradient Colors & Tap Gesture",
            icon: "swirl.circle.righthalf.filled",
            color: .pink,
            description: "Tap it to change the gradient colors",
            view: AnyView(GradientColorsWithTapGesture()),
            toolbarColor: .white
        ),
    ]
}
