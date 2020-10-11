**ENUM**

# `LoggerData.LoggerTarget`

```swift
public enum LoggerTarget : String, Codable
```

Messages can be directed to the console, a file, or both

## Cases
### `file`

```swift
case file
```

Write log to disk

### `terminal`

```swift
case terminal
```

Show log in UI (including terminal)

### `both`

```swift
case both
```

Show and write
