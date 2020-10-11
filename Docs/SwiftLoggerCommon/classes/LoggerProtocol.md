**CLASS**

# `LoggerProtocol`

```swift
public class LoggerProtocol: NWProtocolFramerImplementation
```

## Methods
### `init(framer:)`

```swift
public required init(framer: NWProtocolFramer.Instance)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | A new instance of the framer protocol. |

### `start(framer:)`

```swift
public func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |

### `wakeup(framer:)`

```swift
public func wakeup(framer: NWProtocolFramer.Instance)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |

### `stop(framer:)`

```swift
public func stop(framer: NWProtocolFramer.Instance) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |

### `cleanup(framer:)`

```swift
public func cleanup(framer: NWProtocolFramer.Instance)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |

### `handleOutput(framer:message:messageLength:isComplete:)`

```swift
public func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |
| message | The length of the data associated with this message send. If the message is not complete, the length represents the partial message length being sent, which may be smaller than the complete message length. |
| isComplete | A boolean indicating whether or not the message is now complete. |

### `handleInput(framer:)`

```swift
public func handleInput(framer: NWProtocolFramer.Instance) -> Int
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| framer | The instance of the framer protocol. |