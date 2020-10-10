// Available only on Apple's platforms beginning at MacOS 10.15, ie swift 5
#if !os(Linux)
#if swift(>=5)

import Foundation
import Network

public protocol PeerConnectionDelegate: class {
    func connectionReady(_ c: PeerConnection)
    func connectionFailed(_ c: PeerConnection)
    func receivedMessage(_ c: PeerConnection, content: Data?, message: NWProtocolFramer.Message)
    func displayAdvertiseError(_ error: NWError)
}

public class PeerConnection : Equatable {
    public private(set) var id: UUID = UUID()
    public static func == (lhs: PeerConnection, rhs: PeerConnection) -> Bool {
        lhs.id == rhs.id
    }
    weak var delegate: PeerConnectionDelegate?
    var connection: NWConnection?
    let initiatedConnection: Bool

    // Create an outbound connection when the user initiates a game.
    public init(endpoint: NWEndpoint, interface: NWInterface?, passcode: String, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.initiatedConnection = true

        let connection = NWConnection(to: endpoint, using: NWParameters(passcode: passcode))
        self.connection = connection

        startConnection()
    }

    // Handle an inbound connection when the user receives a game request.
    public init(connection: NWConnection, delegate: PeerConnectionDelegate) {
        self.delegate = delegate
        self.connection = connection
        self.initiatedConnection = false

        startConnection()
    }

    // Handle the user exiting the game.
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
        connection.start(queue: .main)
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

        connection.receiveMessage { (content, context, isComplete, error) in
            // Extract your message type from the received context.
            if let message = context?.protocolMetadata(definition: LoggerProtocol.definition) as? NWProtocolFramer.Message {
                self.delegate?.receivedMessage(self, content: content, message: message)
            }
            if error == nil {
                // Continue to receive more messages until you receive and error.
                self.receiveNextMessage()
            }
        }
    }
}


#endif
#endif
