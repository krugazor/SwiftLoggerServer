**EXTENSION**

# `SwiftLogger`
```swift
extension SwiftLogger
```

## Methods
### `debug(source:line:function:data:fileExtension:target:)`

```swift
public static func debug(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a debug level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `d(source:line:function:data:fileExtension:target:)`

```swift
public static func d(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a debug level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `info(source:line:function:data:fileExtension:target:)`

```swift
public static func info(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an info level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `i(source:line:function:data:fileExtension:target:)`

```swift
public static func i(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an info level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `warning(source:line:function:data:fileExtension:target:)`

```swift
public static func warning(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a warning level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `w(source:line:function:data:fileExtension:target:)`

```swift
public static func w(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs a warning level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `error(source:line:function:data:fileExtension:target:)`

```swift
public static func error(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an error level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `e(source:line:function:data:fileExtension:target:)`

```swift
public static func e(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both)
```

Logs an error level message
- parameters:
  - source: the file the message is originating from (defaults to the current file)
  - line: the line the message is originating from (defaults to the current line)
  - function: the function the message is originating from (defaults to the current function)
  - data: the message to be logged (nil is accepted but will be ignored)
  - fileExtension: the extension of the file if it is to be written to disk
  - target: determines if the message is to be displayed, written to file or both (default both)

#### Parameters

| Name | Description |
| ---- | ----------- |
| source | the file the message is originating from (defaults to the current file) |
| line | the line the message is originating from (defaults to the current line) |
| function | the function the message is originating from (defaults to the current function) |
| data | the message to be logged (nil is accepted but will be ignored) |
| fileExtension | the extension of the file if it is to be written to disk |
| target | determines if the message is to be displayed, written to file or both (default both) |

### `setupForNetwork(passcode:appName:useSpecificServer:)`

```swift
public static func setupForNetwork(passcode: String, appName: String, useSpecificServer: Bool = false)
```

Sets the shared instance for http(s) logging
- parameters:
  - passcode: The String used to recognize the server and encrypt data
  - appName: The app name to use in the logs
  - useSpecificServer: If true, will connect only to a server that broadcasts the app's name

#### Parameters

| Name | Description |
| ---- | ----------- |
| passcode | The String used to recognize the server and encrypt data |
| appName | The app name to use in the logs |
| useSpecificServer | If true, will connect only to a server that broadcasts the app’s name |