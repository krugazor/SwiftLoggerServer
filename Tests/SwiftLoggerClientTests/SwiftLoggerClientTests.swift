/*
 MIT License

 Original idea/implementation
 Copyright (c) 2017 Mladen_K

 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import XCTest
import Foundation
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
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        Kitura.stop()
    }
    
    func testHTTPData() {
        // could not find a way to load an image from within the test architecture
        guard let image = FileManager.default.contents(atPath: "/tmp/screenshot-terminal.png") else {
            XCTFail("Image could not be loaded")
            return
        }
        let router = LoggerRouter.httpLoggerRouter(logToFile: true, logToUI: true)
        Kitura.addHTTPServer(onPort: 8080, with: router.router)
        
        // start the Kitura runloop (this call never returns)
        DispatchQueue.global(qos: .background).async {
            Kitura.run()
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        measure {
            SwiftLogger.i(data: image, fileExtension: "png")
            SwiftLogger.d(data: image, fileExtension: "png")
            SwiftLogger.w(data: image, fileExtension: "png")
            SwiftLogger.e(data: image, fileExtension: "png")
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
        Kitura.stop()
   }

    #if !os(Linux)
    func testNetwork() {
        let router = LoggerRouter.networkLoggerRouter(name: "SwiftLoggerServer")
        
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLoggerServer", useSpecificServer: false)
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
 
    func testNetworkData() {
        // could not find a way to load an image from within the test architecture
        guard let image = FileManager.default.contents(atPath: "/tmp/screenshot-terminal.png") else {
            XCTFail("Image could not be loaded")
            return
        }
        let router = LoggerRouter.networkLoggerRouter(name: "SwiftLoggerServer", logToFile: true, logToUI: true)
        
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLoggerServer", useSpecificServer: false)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        print("trying to connect")
        measure {
            SwiftLogger.i(data: image, fileExtension: "png")
            SwiftLogger.d(data: image, fileExtension: "png")
            SwiftLogger.w(data: image, fileExtension: "png")
            SwiftLogger.e(data: image, fileExtension: "png")
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
    }
#endif
    
    #if !os(Linux)
    static var allTests = [
        ("testHTTP", testHTTP),
        ("testHTTPData", testHTTPData),
        ("testNetwork", testNetwork),
        ("testNetworkData", testNetworkData),
     ]
    #else
    static var allTests = [
        ("testHTTP", testHTTP),
        ("testHTTPData", testHTTPData),
    ]

    #endif
}
