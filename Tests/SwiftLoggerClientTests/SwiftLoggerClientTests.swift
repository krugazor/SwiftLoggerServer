import XCTest
@testable import SwiftLoggerClient

class SwiftLoggerClientTests: XCTestCase {
    func testExample() {
        SwiftLogger.setupForHTTP(URL(string: "http://localhost:8080")!, appName: "Test")
        
        SwiftLogger.i(message: "This is an information")
        SwiftLogger.d(message: "This is a debug message")
        SwiftLogger.w(message: "This is a warning")
        SwiftLogger.e(message: "This is an error")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
