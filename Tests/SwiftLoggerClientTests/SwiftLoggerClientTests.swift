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
@testable import SwiftLoggerRouterKitura

public class SLTestOutput : LoggerRouterDelegate {
    public var writesToFile : Bool { return false }
    public func logMessage(_ message: LoggerData) throws {
        messages.append(message)
    }
    
    var messages: [LoggerData] = []
}

class SwiftLoggerClientTests: XCTestCase {
    func testHTTP() {
        let router = LoggerRouter.httpLoggerRouter(logToFile: false, logToUI: true)
        if let krouter = (router as? KituraLoggerRouter)?.router {
            Kitura.addHTTPServer(onPort: 8080, with: krouter)
        } else {
            XCTFail()
            return
        }
        let logd = SLTestOutput()
        router.addLogger(logd)
        
        // start the Kitura runloop (this call never returns)
        DispatchQueue.global(qos: .background).async {
            Kitura.run()
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        var loops = 0
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
            loops += 1
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        Kitura.stop()
        
        var logsi = 0
        var logsd = 0
        var logsw = 0
        var logse = 0
        
        for log in logd.messages {
            switch log.logType {
            case .DEBUG:
                logsd += 1
            case .INFO:
                logsi += 1
            case .WARNING:
                logsw += 1
            case .ERROR:
                logse += 1
            }
        }
        
        XCTAssert(logsi == loops)
        XCTAssert(logsd == loops)
        XCTAssert(logsw == loops)
        XCTAssert(logse == loops)
    }
    
    func testHTTPData() {
        // could not find a way to load an image from within the test architecture
        guard let image = FileManager.default.contents(atPath: "/tmp/screenshot-terminal.png") else {
            XCTFail("Image could not be loaded")
            return
        }
        let router = LoggerRouter.httpLoggerRouter(logToFile: true, logToUI: true)
        if let krouter = (router as? KituraLoggerRouter)?.router {
            Kitura.addHTTPServer(onPort: 8080, with: krouter)
        } else {
            XCTFail()
            return
        }
        
        let logd = SLTestOutput()
        router.addLogger(logd)
        
        // start the Kitura runloop (this call never returns)
        DispatchQueue.global(qos: .background).async {
            Kitura.run()
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        var loops = 0
        measure {
            SwiftLogger.i(data: image, fileExtension: "png")
            SwiftLogger.d(data: image, fileExtension: "png")
            SwiftLogger.w(data: image, fileExtension: "png")
            SwiftLogger.e(data: image, fileExtension: "png")
            loops += 1
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
        Kitura.stop()
        
        var logsi = 0
        var logsd = 0
        var logsw = 0
        var logse = 0
        
        for log in logd.messages {
            switch log.logType {
            case .DEBUG:
                logsd += 1
            case .INFO:
                logsi += 1
            case .WARNING:
                logsw += 1
            case .ERROR:
                logse += 1
            }
        }
        
        XCTAssert(logsi == loops)
        XCTAssert(logsd == loops)
        XCTAssert(logsw == loops)
        XCTAssert(logse == loops)
    }
    
    #if !os(Linux)
    func testNetwork() {
        let router = LoggerRouter.networkLoggerRouter(name: "SwiftLoggerServer")
        
        let logd = SLTestOutput()
        router.addLogger(logd)
        
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLoggerServer", useSpecificServer: false)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        print("trying to connect")
        var loops = 0
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
            loops += 1
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        var logsi = 0
        var logsd = 0
        var logsw = 0
        var logse = 0
        
        for log in logd.messages {
            switch log.logType {
            case .DEBUG:
                logsd += 1
            case .INFO:
                logsi += 1
            case .WARNING:
                logsw += 1
            case .ERROR:
                logse += 1
            }
        }
        
        XCTAssert(logsi == loops)
        XCTAssert(logsd == loops)
        XCTAssert(logsw == loops)
        XCTAssert(logse == loops)
    }
    
    func testNetworkData() {
        // could not find a way to load an image from within the test architecture
        guard let image = FileManager.default.contents(atPath: "/tmp/screenshot-terminal.png") else {
            XCTFail("Image could not be loaded")
            return
        }
        let router = LoggerRouter.networkLoggerRouter(name: "SwiftLoggerServer", logToFile: true, logToUI: true)
        
        let logd = SLTestOutput()
        router.addLogger(logd)
        
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLoggerServer", useSpecificServer: false)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        print("trying to connect")
        var loops = 0
        measure {
            SwiftLogger.i(data: image, fileExtension: "png")
            SwiftLogger.d(data: image, fileExtension: "png")
            SwiftLogger.w(data: image, fileExtension: "png")
            SwiftLogger.e(data: image, fileExtension: "png")
            loops += 1
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        
        var logsi = 0
        var logsd = 0
        var logsw = 0
        var logse = 0
        
        for log in logd.messages {
            switch log.logType {
            case .DEBUG:
                logsd += 1
            case .INFO:
                logsi += 1
            case .WARNING:
                logsw += 1
            case .ERROR:
                logse += 1
            }
        }
        
        XCTAssert(logsi == loops)
        XCTAssert(logsd == loops)
        XCTAssert(logsw == loops)
        XCTAssert(logse == loops)
    }
    
    func testNetworkUI() {
        // could not find a way to load an image from within the test architecture
        guard let image = FileManager.default.contents(atPath: "/tmp/screenshot-terminal.png") else {
            XCTFail("Image could not be loaded")
            return
        }
        SwiftLogger.setupForNetwork(passcode: LoggerData.defaultPasscode, appName: "SwiftLoggerServer", useSpecificServer: false)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        print("trying to connect")
        let data = "Some Random Gibberish Data For Data Cells. Some Random Gibberish Data For Data Cells. Some Random Gibberish Data For Data Cells. Some Random Gibberish Data For Data Cells.".data(using: .utf8)!
        measure {
            SwiftLogger.i(message: "This is an information")
            SwiftLogger.d(message: "This is a debug message")
            SwiftLogger.w(message: "This is a warning")
            SwiftLogger.e(message: "This is an error")
            SwiftLogger.i(data: image, fileExtension: "png")
            SwiftLogger.d(data: image, fileExtension: "png")
            SwiftLogger.w(data: image, fileExtension: "png")
            SwiftLogger.e(data: image, fileExtension: "png")
            SwiftLogger.i(data: data, fileExtension: nil)
            SwiftLogger.d(data: data, fileExtension: nil)
            SwiftLogger.w(data: data, fileExtension: nil)
            SwiftLogger.e(data: data, fileExtension: nil)
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
