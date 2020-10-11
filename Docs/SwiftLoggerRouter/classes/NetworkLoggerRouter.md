**CLASS**

# `NetworkLoggerRouter`

```swift
public class NetworkLoggerRouter : LoggerRouter, PeerConnectionDelegate
```

`Network.framework` logger server

## Properties
### `delegate`

```swift
public weak var delegate: PeerConnectionDelegate?
```

### `name`

```swift
public var name: String
```

The listener

## Methods
### `startListening()`

```swift
public func startListening()
```

Start listening and advertising.

### `connectionReady(_:)`

```swift
public func connectionReady(_ conn: PeerConnection)
```

### `connectionFailed(_:)`

```swift
public func connectionFailed(_ conn: PeerConnection)
```

### `receivedMessage(_:content:message:)`

```swift
public func receivedMessage(_ conn: PeerConnection, content: Data?, message: NWProtocolFramer.Message)
```

### `displayAdvertiseError(_:)`

```swift
public func displayAdvertiseError(_ error: NWError)
```
