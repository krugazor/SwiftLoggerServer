import XCTest
import Kitura
#if os(Linux)
import Dispatch
#endif
import SwiftLoggerCommon
@testable import SwiftLoggerClient
@testable import SwiftLoggerRouter

class SwiftLoggerClientTests: XCTestCase {
    func testHTTP() {
        let router = LoggerRouter.httpLoggerRouter(logToFile: false, logToUI: true)
        Kitura.addHTTPServer(onPort: 8080, with: router.router)
        
        // start the Kitura runloop (this call never returns)
        DispatchQueue.global(qos: .background).async {
            Kitura.run()
        }
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
        }
    }
    
    #if !os(Linux)
    func testNetwork() {
        let router = LoggerRouter.networkLoggerRouter(name: "SwiftLogger Server")
        
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLogger Server")
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        print("trying to connect")
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }
    #endif
    
    #if !os(Linux)
    static var allTests = [
        ("testHTTP", testHTTP),
        ("testNetwork", testNetwork),
     ]
    #else
    static var allTests = [
        ("testHTTP", testHTTP),
     ]

    #endif
}
