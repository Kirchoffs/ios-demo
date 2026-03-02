# Notes
## Basics
### Opaque Type
#### Opaque Type
```swift
func makeShape() -> some Shape {
    return Rectangle()
}
```

#### Concrete Type
```swift
func makeRectangle() -> Rectangle {
    return Rectangle()
}
```

#### Protocol Type
```swift
func makeAnyShape() -> Shape {
    return Bool.random() ? Rectangle() : Circle()
}
```
