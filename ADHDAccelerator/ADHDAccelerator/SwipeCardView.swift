import SwiftUI
import SwiftData

struct SwipeCardView: View {
    @Bindable var task: TaskItem
    var onSwipe: (Bool) -> Void
    
    @State private var offset: CGSize = .zero
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            CardContainer {
                Text(task.content)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .rotation3DEffect(.degrees(isFlipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 0 : 1)
            .allowsHitTesting(!isFlipped)
            
            CardContainer {
                NotepadView(note: $task.note)
            }
            .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 1 : 0)
            .allowsHitTesting(isFlipped)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        if isFlipped { hideKeyboard() }
                        withAnimation(.spring(duration: 0.18)) {
                            isFlipped.toggle()
                        }
                    } label: {
                        Image(systemName: isFlipped ? "arrow.left.circle.fill" : "note.text.badge.plus")
                            .font(.system(size: 28))
                            .foregroundColor(.orange.opacity(0.8))
                            .padding(18)
                    }
                }
                Spacer()
            }
        }
        .offset(x: isFlipped ? 0 : offset.width)
        .rotationEffect(.degrees(isFlipped ? 0 : Double(offset.width / 25)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if !isFlipped {
                        offset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if !isFlipped {
                        if offset.width > 225 {
                            completeAction(success: true)
                        } else if offset.width < -225 {
                            completeAction(success: false)
                        } else {
                            withAnimation(.spring()) { offset = .zero }
                        }
                    }
                }
        )
        .onTapGesture(count: 2) {
            if !isFlipped {
                withAnimation(.spring(duration: 0.5)) {
                    isFlipped.toggle()
                }
            }
        }
        .background(
            HStack {
                Image(systemName: "xmark.circle.fill").foregroundColor(.red).opacity(offset.width < 0 ? 1 : 0)
                Spacer()
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green).opacity(offset.width > 0 ? 1 : 0)
            }
            .font(.system(size: 48))
            .padding(45)
            .opacity(isFlipped ? 0 : 1)
        )
    }
    
    private func completeAction(success: Bool) {
        withAnimation(.easeInOut(duration: 0.4)) {
            offset.width = success ? 425 : -425
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onSwipe(success)
            offset = .zero
        }
    }
}

struct CardContainer<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.secondarySystemBackground))
            
            content()
        }
    }
}

struct NotepadView: View {
    @Binding var note: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pencil.and.outline")
                Text("Notes")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.secondary)
            .padding(.bottom, 5)
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            
            TextEditor(text: $note)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .padding(.all, 12)
                .background(Color.orange.opacity(0.06))
                .cornerRadius(12)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .lineSpacing(8)
                .foregroundStyle(Color.brown)
        }
        .padding(25)
        .contentShape(Rectangle())
        .onTapGesture { hideKeyboard() }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
