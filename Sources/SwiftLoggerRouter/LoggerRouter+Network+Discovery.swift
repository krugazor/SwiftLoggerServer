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
import SwiftLoggerCommon

/// `Network.framework` logger server
public class NetworkLoggerRouter : LoggerRouter, PeerConnectionDelegate {
    public weak var delegate: PeerConnectionDelegate? /// If we need to react to connection events (UI for example)
    var listener: NWListener? /// The listener
    public var name: String { /// The name of the service (used if the app is looking for a specific server)
        didSet {
            self.resetName(name)
        }
    }
    let passcode: String /// The passcode used to encrypt the communication
    
    private var networkListener : NWListener?
    private var networkConnections : [PeerConnection] = []

    /// Create a listener with a name to advertise, a passcode for authentication,
    /// and a delegate to handle inbound connections.
    /// Private initializer for internal use
    init(name: String,
         passcode: String = LoggerData.defaultPasscode,
         delegate: PeerConnectionDelegate? = nil,
         dataDir: String? = nil,
         logToFile: Bool = false,
         logToUI: Bool = true) {
        self.delegate = delegate
        self.name = name
        self.passcode = passcode
        
        super.init(dataDir: dataDir, logToFile: logToFile, logToUI: logToUI)
        
        startListening()
    }

    /// Start listening and advertising.
    public func startListening() {
        do {
            // Create the listener object.
            let listener = try NWListener(using: NWParameters(passcode: passcode))
            self.listener = listener

            // Set the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_swiftlogger._tcp")

            listener.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    self.logToDelegates(loggerData: LoggerData(appName: "SwiftLoggerServer",
                                                          logType: .INFO,
                                                          logTarget: .both,
                                                          sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                          lineNumber: #line,
                                                          function: #function,
                                                          logText: "Listener ready on \(listener.port ?? 0)"))
                case .failed(let error):
                    // If the listener fails, re-start.
                    if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
                        self.logToDelegates(loggerData: LoggerData(appName: "SwiftLoggerServer",
                                                              logType: .ERROR,
                                                              logTarget: .both,
                                                              sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                              lineNumber: #line,
                                                              function: #function,
                                                              logText: "Listener failed with \(error), restarting"))
                        listener.cancel()
                        self.startListening()
                    } else {
                        self.logToDelegates(loggerData: LoggerData(appName: "SwiftLoggerServer",
                                                              logType: .ERROR,
                                                              logTarget: .both,
                                                              sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                              lineNumber: #line,
                                                              function: #function,
                                                              logText: "Listener failed with \(error), stopping"))
                        self.delegate?.displayAdvertiseError(error)
                        listener.cancel()
                    }
                case .cancelled:
                    self.networkListener = nil
                default:
                    break
                }
            }

            listener.newConnectionHandler = { newConnection in
                print("incoming connection")
                self.networkConnections.append(PeerConnection(connection: newConnection, delegate: self))
            }

            // Start listening, and request updates on the main queue.
            listener.start(queue: .global(qos: .userInteractive))
        } catch {
            self.logToDelegates(loggerData: LoggerData(appName: "SwiftLoggerServer",
                                                  logType: .ERROR,
                                                  logTarget: .both,
                                                  sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                  lineNumber: #line,
                                                  function: #function,
                                                  logText: "Failed to create listener\n\(error.localizedDescription)"))
            abort()
        }
    }

    /// If the user changes their name, update the advertised name.
    /// - parameters:
    ///   - name: the new name to use
    func resetName(_ name: String) {
        self.name = name
        if let listener = listener {
            // Reset the service to advertise.
            listener.service = NWListener.Service(name: self.name, type: "_swiftlogger._tcp")
        }
    }

    // MARK: -
    public func connectionReady(_ conn: PeerConnection) {
        delegate?.connectionReady(conn)
        
        if delegate == nil {
            logToDelegates(loggerData: LoggerData(appName: "LoggerServer",
                                                  logType: .INFO,
                                                  logTarget: .both,
                                                  sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                  lineNumber: #line,
                                                  function: #function,
                                                  logText: "Connection ready with \(conn.id)"))
        }
    }
    
    public func connectionFailed(_ conn: PeerConnection) {
        networkConnections.removeAll(where: { $0 == conn })
        delegate?.connectionReady(conn)
 
        if delegate == nil {
            logToDelegates(loggerData: LoggerData(appName: "LoggerServer",
                                                  logType: .WARNING,
                                                  logTarget: .both,
                                                  sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                                  lineNumber: #line,
                                                  function: #function,
                                                  logText: "Connection failed with \(conn.id), will retry"))
        }
    }
    
    public func receivedMessage(_ conn: PeerConnection, content: Data?, message: NWProtocolFramer.Message) {
        delegate?.receivedMessage(conn, content: content, message: message)
        if delegate == nil {
            if let content = content, let log = try? JSONDecoder().decode(LoggerData.self, from: content) {
                logToDelegates(loggerData: log)
            }
        }
   }
    
    public func displayAdvertiseError(_ error: NWError) {
        delegate?.displayAdvertiseError(error)
        logToDelegates(loggerData: LoggerData(appName: "LoggerServer",
                                              logType: .ERROR,
                                              logTarget: .both,
                                              sourceFile: URL(fileURLWithPath: #file).lastPathComponent,
                                              lineNumber: #line,
                                              function: #function,
                                              logText: error.localizedDescription))
   }

}

#endif
#endif
