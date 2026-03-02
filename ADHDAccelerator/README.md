# Notes
## Build
```
>> xcodebuild -scheme ADHDAccelerator -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Miscellaneaous
### Key Path
```swift
struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    // @Environment(\EnvironmentValues.modelContext) private var modelContext
}
```

```swift
@propertyWrapper 
struct Environment<Value> {
    init(_ keyPath: KeyPath<EnvironmentValues, Value>)
}
```

### TimeInterval
Double & Seconds

### Button
```swift
init(_ title: String, action: @escaping () -> Void)
```

#### Trailing Closure
```swift
Button("Add Group", action: {
    isCreatingNew = true
    isShowingEditor = true
})

Button("Add Group") {
    isCreatingNew = true
    isShowingEditor = true
}
```
