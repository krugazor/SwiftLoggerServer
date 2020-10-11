**CLASS**

# `ConsoleLogger`

```swift
public class ConsoleLogger : LoggerRouterDelegate
```

Standard (colorized) console logger

## Properties
### `writesToFile`

```swift
public var writesToFile: Bool
```

Does not write to file

## Methods
### `logMessage(_:)`

```swift
public func logMessage(_ loggerData : LoggerData) throws
```

Displays the (colorized) message on the console
- parameters:
  - loggerData: the data to display, truncates data if necessary

#### Parameters

| Name | Description |
| ---- | ----------- |
| loggerData | the data to display, truncates data if necessary |