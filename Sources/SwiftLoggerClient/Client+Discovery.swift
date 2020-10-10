// Available only on Apple's platforms beginning at MacOS 10.15, ie swift 5
#if !os(Linux)
#if swift(>=5)

import Foundation
import Network
import SwiftLoggerCommon

class NetworkSwiftLogger : SwiftLogger {
    var browser: NWBrowser?
    var name: String
    var passcode: String
    var connection: PeerConnection?

    // Create a browsing object with a delegate.
    init(name n: String, passcode p: String?) {
        name = n
        passcode = p ?? LoggerData.defaultPasscode
        super.init(URL(fileURLWithPath: "/dev/null"), appName: n)
        startBrowsing()
    }

    // Start browsing for services.
    func startBrowsing() {
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true

        let browser = NWBrowser(for: .bonjour(type: "_swiftlogger._tcp", domain: nil), using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                // Restart the browser if it loses its connection
                if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
                    print("Browser failed with \(error), restarting")
                    browser.cancel()
                    self.startBrowsing()
                } else {
                    print("Browser failed with \(error), stopping")
                    browser.cancel()
                }
            case .ready:
                if self.connection == nil {
                    for result in browser.browseResults {
                        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                            if name == self.name {
                                self.connection = PeerConnection(endpoint: result.endpoint,
                                                                  interface: result.interfaces.first,
                                                                  passcode: self.passcode,
                                                                  delegate: self)
                                break
                            }
                        }
                    }
                }
            case .cancelled:
                break
            default:
                break
            }
        }

        // When the list of discovered endpoints changes, refresh the delegate.
        browser.browseResultsChangedHandler = { results, changes in
            if self.connection == nil {
                for result in browser.browseResults {
                    if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                        if name == self.name {
                            self.connection = PeerConnection(endpoint: result.endpoint,
                                                              interface: result.interfaces.first,
                                                              passcode: self.passcode,
                                                              delegate: self)
                            break
                        }
                    }
                }
            }
        }

        // Start browsing and ask for updates on the main queue.
        browser.start(queue: .main)
    }
    
    override func send(_ log: LoggerData, success: @escaping (Bool) -> Void) {
        self.connection?.sendLog(log)
        success(true)
    }
}

extension NetworkSwiftLogger : PeerConnectionDelegate {
    func connectionReady(_ c: PeerConnection) {
        // this space for rent
    }
    
    func connectionFailed(_ c: PeerConnection) {
        // this space for rent
    }
    
    func receivedMessage(_ c: PeerConnection, content: Data?, message: NWProtocolFramer.Message) {
        // this space for rent
    }
    
    func displayAdvertiseError(_ error: NWError) {
        // this space for rent
    }
}

extension SwiftLogger {
    public static func setupForNetwork(passcode: String, appName: String) {
        _sharedInstance = NetworkSwiftLogger(name: appName, passcode: passcode)
    }

}

#endif
#endif
