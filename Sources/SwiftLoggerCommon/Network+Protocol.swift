// Available only on Apple's platforms beginning at MacOS 10.15, ie swift 5
#if !os(Linux)
#if swift(>=5)

import Foundation
import Network

enum LoggerProtocolMessageType: UInt32 {
    case invalid = 0
    case message = 1
    case reply = 2
}
public class LoggerProtocol: NWProtocolFramerImplementation {

    // Create a global definition of your game protocol to add to connections.
    public static let definition = NWProtocolFramer.Definition(implementation: LoggerProtocol.self)

    // Set a name for your protocol for use in debugging.
    public static var label: String { return "SwiftLogger" }

    // Set the default behavior for most framing protocol functions.
    public required init(framer: NWProtocolFramer.Instance) { }
    public func start(framer: NWProtocolFramer.Instance) -> NWProtocolFramer.StartResult { return .ready }
    public func wakeup(framer: NWProtocolFramer.Instance) { }
    public func stop(framer: NWProtocolFramer.Instance) -> Bool { return true }
    public func cleanup(framer: NWProtocolFramer.Instance) { }

    // Whenever the application sends a message, add your protocol header and forward the bytes.
    public func handleOutput(framer: NWProtocolFramer.Instance, message: NWProtocolFramer.Message, messageLength: Int, isComplete: Bool) {
        let type = message.messageType
        
        let header = LogMessageHeader(type.rawValue, UInt32(messageLength))
        framer.writeOutput(data: header.encodedData)

        // Ask the connection to insert the content of the application message after your header.
        do {
            try framer.writeOutputNoCopy(length: messageLength)
        } catch let error {
            print("Hit error writing \(error)")
        }
    }
    
    // Whenever new bytes are available to read, try to parse out your message format.
    public func handleInput(framer: NWProtocolFramer.Instance) -> Int {
        while true {
            // Try to read out a single header.
            var tempHeader: LogMessageHeader? = nil
            let headerSize = LogMessageHeader.encodedSize
            let parsed = framer.parseInput(minimumIncompleteLength: headerSize,
                                           maximumLength: headerSize) { (buffer, isComplete) -> Int in
                guard let buffer = buffer else {
                    return 0
                }
                if buffer.count < headerSize {
                    return 0
                }
                tempHeader = LogMessageHeader(buffer)
                return headerSize
            }

            // If you can't parse out a complete header, stop parsing and ask for headerSize more bytes.
            guard parsed, let header = tempHeader else {
                return headerSize
            }

            // Create an object to deliver the message.
            var messageType = LoggerProtocolMessageType.invalid
            if let parsedMessageType = LoggerProtocolMessageType(rawValue: header.type) {
                messageType = parsedMessageType
            }
            let message = NWProtocolFramer.Message(messageType: messageType)

            // Deliver the body of the message, along with the message object.
            if !framer.deliverInputNoCopy(length: Int(header.length), message: message, isComplete: true) {
                return 0
            }
        }
    }
}

// Extend framer messages to handle storing your command types in the message metadata.
extension NWProtocolFramer.Message {
    convenience init(messageType: LoggerProtocolMessageType) {
        self.init(definition: LoggerProtocol.definition)
        self["MessageType"] = messageType
    }

    var messageType: LoggerProtocolMessageType {
        if let type = self["MessageType"] as? LoggerProtocolMessageType {
            return type
        } else {
            return .invalid
        }
    }
}

/// Log Message Header needs to come first on the wire to provide a suitable length of bytes to read
struct LogMessageHeader : Codable {
    let type: UInt32
    let length: UInt32

    init(_ type: UInt32, _ length: UInt32) {
        self.type = type
        self.length = length
    }

    init(_ buffer: UnsafeMutableRawBufferPointer) {
        var tempType: UInt32 = 0
        var tempLength: UInt32 = 0
        withUnsafeMutableBytes(of: &tempType) { typePtr in
            typePtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: 0),
                                                            count: MemoryLayout<UInt32>.size))
        }
        withUnsafeMutableBytes(of: &tempLength) { lengthPtr in
            lengthPtr.copyMemory(from: UnsafeRawBufferPointer(start: buffer.baseAddress!.advanced(by: MemoryLayout<UInt32>.size),
                                                              count: MemoryLayout<UInt32>.size))
        }
        type = tempType
        length = tempLength
    }

    var encodedData: Data {
        var tempType = type
        var tempLength = length
        var data = Data(bytes: &tempType, count: MemoryLayout<UInt32>.size)
        data.append(Data(bytes: &tempLength, count: MemoryLayout<UInt32>.size))
        return data
    }

    static var encodedSize: Int {
        return MemoryLayout<UInt32>.size * 2
    }
}

#endif
#endif
