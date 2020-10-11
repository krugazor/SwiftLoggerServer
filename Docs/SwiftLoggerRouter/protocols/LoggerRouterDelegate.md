**PROTOCOL**

# `LoggerRouterDelegate`

```swift
public protocol LoggerRouterDelegate
```

    Error message
Logger delegate which handles the actual writing or displaying of the messages

## Properties
### `writesToFile`

```swift
var writesToFile : Bool
```

Whether or not this type writes to file (for filtering purposes). If false, UI display is assumed

## Methods
### `logMessage(_:)`

```swift
func logMessage(_ message: LoggerData) throws
```

Writes or displays the log message
