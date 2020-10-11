**STRUCT**

# `LoggerData`

```swift
public struct LoggerData : Codable
```

logger data model

## Properties
### `appName`

```swift
public let appName: String
```

App name, used for naming the file too

### `logType`

```swift
public let logType: LoggerType
```

Message level

### `logTarget`

```swift
public let logTarget: LoggerTarget
```

Message target

### `sourceFile`

```swift
public let sourceFile: String
```

Source file of origin

### `lineNumber`

```swift
public let lineNumber: Int
```

Source line of origin

### `function`

```swift
public let function: String
```

Source function of origin

### `logText`

```swift
public let logText: String?
```

Text of the message

### `logData`

```swift
public let logData: Data?
```

Data of the message (eg image, sound, etc)

### `logDataExt`

```swift
public let logDataExt: String?
```

File extension to use when writing that data to disk

## Methods
### `init(appName:logType:logTarget:sourceFile:lineNumber:function:logText:)`

```swift
public init(
    appName apn: String,
    logType lty: LoggerType,
    logTarget lta: LoggerTarget,
    sourceFile sof: String,
    lineNumber lin: Int,
    function fun: String,
    logText text: String
)
```

Text message initializer
- parameters:
  - appName: App name, used for naming the file too
  - logType: Message level
  - logTarget: Message target
  - sourceFile: Source file of origin
  - lineNumber: Source line of origin
  - function: Source function of origin
  - logText: Text of the message

#### Parameters

| Name | Description |
| ---- | ----------- |
| appName | App name, used for naming the file too |
| logType | Message level |
| logTarget | Message target |
| sourceFile | Source file of origin |
| lineNumber | Source line of origin |
| function | Source function of origin |
| logText | Text of the message |

### `init(appName:logType:logTarget:sourceFile:lineNumber:function:logData:dataExtension:)`

```swift
public init(
    appName apn: String,
    logType lty: LoggerType,
    logTarget lta: LoggerTarget,
    sourceFile sof: String,
    lineNumber lin: Int,
    function fun: String,
    logData data: Data,
    dataExtension ext: String?
)
```

Data message initializer
- parameters:
  - appName: App name, used for naming the file too
  - logType: Message level
  - logTarget: Message target
  - sourceFile: Source file of origin
  - lineNumber: Source line of origin
  - function: Source function of origin
  - logData: Data of the message (eg image, sound, etc)
  - dataExtension: File extension to use when writing that data to disk

#### Parameters

| Name | Description |
| ---- | ----------- |
| appName | App name, used for naming the file too |
| logType | Message level |
| logTarget | Message target |
| sourceFile | Source file of origin |
| lineNumber | Source line of origin |
| function | Source function of origin |
| logData | Data of the message (eg image, sound, etc) |
| dataExtension | File extension to use when writing that data to disk |