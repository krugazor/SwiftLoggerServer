**CLASS**

# `SwiftLogger`

```swift
public class SwiftLogger
```

Entry-point class for logging to a remote instance

## Properties
### `debug`

```swift
public var debug : Bool = false
```

Toggle on and off to display debug messages about how SwiftLogger is doing

## Methods
### `setupForHTTP(_:appName:)`

```swift
public static func setupForHTTP(_ url: URL, appName: String)
```

Sets the shared instance for http(s) logging
- parameters:
  - url: The base server URL (/logger will be added)
  - appName: The app name to use in the logs

#### Parameters

| Name | Description |
| ---- | ----------- |
| url | The base server URL (/logger will be added) |
| appName | The app name to use in the logs |

### `debug(source:line:function:message:target:)`

```swift
public static func debug(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a debug level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `d(source:line:function:message:target:)`

```swift
public static func d(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a debug level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `info(source:line:function:message:target:)`

```swift
public static func info(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an info level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `i(source:line:function:message:target:)`

```swift
public static func i(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an info level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `warning(source:line:function:message:target:)`

```swift
public static func warning(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a warning level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `w(source:line:function:message:target:)`

```swift
public static func w(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a warning level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `error(source:line:function:message:target:)`

```swift
public static func error(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an error level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `e(source:line:function:message:target:)`

```swift
public static func e(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an error level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - message: the message to be logged (nil is accepted but will be ignored)
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| message | the message to be logged (nil is accepted but will be ignored) |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `send(_:success:)`

```swift
open func send(_ log: LoggerData, success: @escaping (Bool)->Void)
```

For overriding purposes send is open (http and network and maybe others)
