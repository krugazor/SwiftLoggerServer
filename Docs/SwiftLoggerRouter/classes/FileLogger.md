**CLASS**

# `FileLogger`

```swift
public class FileLogger : LoggerRouterDelegate
```

Standard file writer logger (.log files)

## Properties
### `writesToFile`

```swift
public var writesToFile: Bool
```

Does write to file

## Methods
### `init(_:)`

```swift
public init(_ dir: String)
```

Creates a new instance
- parameters:
  - dir: the directory to write log files to

#### Parameters

| Name | Description |
| ---- | ----------- |
| dir | the directory to write log files to |

### `logMessage(_:)`

```swift
public func logMessage(_ loggerData : LoggerData) throws
```

Appends message to the file(s)
- parameters:
  - loggerData: the data to append, writes data packets to a separate file

#### Parameters

| Name | Description |
| ---- | ----------- |
| loggerData | the data to append, writes data packets to a separate file |