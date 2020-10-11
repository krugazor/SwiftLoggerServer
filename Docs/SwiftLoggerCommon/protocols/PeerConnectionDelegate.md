**PROTOCOL**

# `PeerConnectionDelegate`

```swift
public protocol PeerConnectionDelegate : AnyObject
```

Delegate for the logging connection

## Methods
### `connectionReady(_:)`

```swift
func connectionReady(_ conn: PeerConnection)
```

Connection is ready and active

### `connectionFailed(_:)`

```swift
func connectionFailed(_ conn: PeerConnection)
```

Connection has failed

### `receivedMessage(_:content:message:)`

```swift
func receivedMessage(_ conn: PeerConnection, content: Data?, message: NWProtocolFramer.Message)
```

Message to be decoded

### `displayAdvertiseError(_:)`

```swift
func displayAdvertiseError(_ error: NWError)
```

Error with the Zeroconf/Bonjour stack
