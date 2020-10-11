**EXTENSION**

# `SwiftLogger`
```swift
extension SwiftLogger
```

## Methods
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