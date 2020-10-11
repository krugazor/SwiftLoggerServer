**CLASS**

# `PeerConnection`

```swift
public class PeerConnection : Equatable
```

Class for handling the actual connection, should not be used directly. It is public for the other frameworks' consumption

## Properties
### `id`

```swift
public private(set) var id: UUID = UUID()
```

## Methods
### `==(_:_:)`

```swift
public static func == (lhs: PeerConnection, rhs: PeerConnection) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A value to compare. |
| rhs | Another value to compare. |

### `init(endpoint:interface:passcode:delegate:)`

```swift
public init(endpoint: NWEndpoint, interface: NWInterface?, passcode: String, delegate: PeerConnectionDelegate)
```

### `init(connection:delegate:)`

```swift
public init(connection: NWConnection, delegate: PeerConnectionDelegate)
```

### `cancel()`

```swift
public func cancel()
```

### `sendLog(_:)`

```swift
public func sendLog(_ log: LoggerData)
```
