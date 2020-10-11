**CLASS**

# `LoggerRouter`

```swift
public class LoggerRouter
```

The standard Kitura router wrapper capable of accepting http connections

## Properties
### `router`

```swift
public private(set) var router : Router
```

The Kitura router

### `logDelegates`

```swift
public var logDelegates : [LoggerRouterDelegate] = []
```

All loggers connected to this instance

## Methods
### `addLogger(_:)`

```swift
public func addLogger(_ logd: LoggerRouterDelegate)
```

Adds a new logger (conforming to `LoggerRouterDelegate`)
- parameters:
  - logd: the logger to use

#### Parameters

| Name | Description |
| ---- | ----------- |
| logd | the logger to use |

### `httpLoggerRouter(dataDir:logToFile:logToUI:)`

```swift
public static func httpLoggerRouter(dataDir: String? = nil, logToFile: Bool = false, logToUI: Bool = true) -> LoggerRouter
```

Starts a new HTTP endpoint for logging (not secure, anyone and anything can log to it)
- parameters:
  - dataDir: the directory to write log files to (if applicable)
  - logToFile: install the default file logger (default: false)
  - logToUI: install the default console logger (default: true)
- returns: The configured server to be used with Kitura

#### Parameters

| Name | Description |
| ---- | ----------- |
| dataDir | the directory to write log files to (if applicable) |
| logToFile | install the default file logger (default: false) |
| logToUI | install the default console logger (default: true) |

### `networkLoggerRouter(name:passcode:delegate:dataDir:logToFile:logToUI:)`

```swift
public static func networkLoggerRouter(name: String,
                                       passcode: String = LoggerData.defaultPasscode,
                                       delegate: PeerConnectionDelegate? = nil,
                                       dataDir: String? = nil,
                                       logToFile: Bool = false,
                                       logToUI: Bool = true) -> NetworkLoggerRouter
```

Starts a new `Network.framework` endpoint for logging (kind of secure, traffic at least is encrypted)
Available only on Apple platforms, beginning at Swift 5 (macOS 10.15, iOS 
- parameters:
  - dataDir: the directory to write log files to (if applicable)
  - logToFile: install the default file logger (default: false)
  - logToUI: install the default console logger (default: true)
- returns: A configured and started server

#### Parameters

| Name | Description |
| ---- | ----------- |
| dataDir | the directory to write log files to (if applicable) |
| logToFile | install the default file logger (default: false) |
| logToUI | install the default console logger (default: true) |