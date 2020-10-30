/*
 MIT License

 Original idea/implementation
 Copyright (c) 2017 Mladen_K

 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

// Available only on Apple's platforms beginning at MacOS 10.15, ie swift 5
#if !os(Linux)
#if swift(>=5)

import Foundation
import Network

/// Delegate for the logging connection
public protocol PeerConnectionDelegate : AnyObject {
    /// Connection is ready and active
    func connectionReady(_ conn: PeerConnection)
    /// Connection has failed
    func connectionFailed(_ conn: PeerConnection)
    /// Message to be decoded
    func receivedMessage(_ conn: PeerConnection, content: Data?, message: NWProtocolFramer.Message)
    /// Error with the Zeroconf/Bonjour stack
    func displayAdvertiseError(_ error: NWError)
}

/// Class for handling the actual connection, should not be used directly. It is public for the other frameworks' consumption
public class PeerConnection : Equatable {
    public private(set) var id: UUID = UUID()
    public static func == (lhs: PeerConnection, rhs: PeerConnection) -> Bool {
        lhs.id == rhs.id
    }
    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let initiatedConnection: Bool

    public init(endpoint: NWEndpoint, interface: NWInterface?, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.initiatedConnection = true

        let connection = NWConnection(to: endpoint, using: NWParameters(passcode: passcode))
        self.connection = connection

        startConnection()
    }

    public init(connection: NWConnection, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.initiatedConnection = false

        startConnection()
    }
    
    deinit {
        cancel()
        delegate = nil
    }

    public func cancel() {
        if let connection = self.connection {
            connection.cancel()
            self.connection = nil
        }
    }

    // Handle starting the peer-to-peer connection for both inbound and outbound connections.
    func startConnection() {
        guard let connection = connection else {
            return
        }

        connection.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                // When the connection is ready, start receiving messages.
                self.receiveNextMessage()

                // Notify your delegate that the connection is ready.
                if let delegate = self.delegate {
                    delegate.connectionReady(self)
                }
            case .failed(let error):
                // Cancel the connection upon a failure.
                connection.cancel()

                // Notify your delegate that the connection failed.
                if let delegate = self.delegate {
                    delegate.connectionFailed(self)
                }
            default:
                break
            }
        }

        // Start the connection establishment.
        connection.start(queue: .global(qos: .background))
    }

    // Handle sending a log message.
    public func sendLog(_ log: LoggerData) {
        guard let connection = connection, let encoded = try? JSONEncoder().encode(log) else {
            return
        }

        // Create a message object to hold the command type.
        let message = NWProtocolFramer.Message(messageType: .message)
        let context = NWConnection.ContentContext(identifier: "LogMessage",
                                                  metadata: [message])

        // Send the application content along with the message.
        connection.send(content: encoded, contentContext: context, isComplete: true, completion: .idempotent)
    }

    // Receive a message, deliver it to your delegate, and continue receiving more messages.
    func receiveNextMessage() {
        guard let connection = connection else {
            return
        }

        connection.receiveMessage { content, context, isComplete, error in
            // Extract your message type from the received context.
            if let message = context?.protocolMetadata(definition: LoggerProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(self, content: content, message: message)
            }
            let finalMessage = context?.isFinal ?? false
            if !finalMessage && error == nil {
                // Continue to receive more messages until you receive and error.
                self.receiveNextMessage()
            }
        }
    }
}

#endif
#endif
