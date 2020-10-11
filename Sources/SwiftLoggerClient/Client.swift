/*
 MIT License
 
 Original idea/implementation
 Copyright (c) 2017 Mladen_K
 
 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import Foundation
import SwiftLoggerCommon
#if os(Linux)
import Dispatch
import FoundationNetworking
#endif

/// Entry-point class for logging to a remote instance
public class SwiftLogger {
    /// Sets the shared instance for http(s) logging
    /// - parameters:
    ///   - url: The base server URL (/logger will be added)
    ///   - appName: The app name to use in the logs
    public static func setupForHTTP(_ url: URL, appName: String) {
        sharedInstance = SwiftLogger(url, appName: appName)
    }
    
    /// Logs a debug level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func debug(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        d(source: source, line: line, function: function, message: message, target: target)
    }
    /// Logs a debug level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func d(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .DEBUG,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { result in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    /// Logs an info level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func info(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        i(source: source, line: line, function: function, message: message, target: target)
    }
    /// Logs an info level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func i(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .INFO,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { result in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    /// Logs a warning level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func warning(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        w(source: source, line: line, function: function, message: message, target: target)
    }
    /// Logs a warning level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func w(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .WARNING,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { (result) in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    /// Logs an error level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func error(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        e(source: source, line: line, function: function, message: message, target: target)
    }
    /// Logs an error level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - message: the message to be logged (nil is accepted but will be ignored)
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func e(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .ERROR,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { result in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    // MARK: -
    var appName : String
    fileprivate var server : URL
    /// Toggle on and off to display debug messages about how SwiftLogger is doing
    public var debug : Bool = false 
    
    init(_ url: URL, appName app: String) { // HTTP client
        server = url
        appName = app
    }
    
    static var sharedInstance : SwiftLogger?
    
    /// For overriding purposes send is open (http and network and maybe others)
    open func send(_ log: LoggerData, success: @escaping (Bool)->Void) {
        sendHTTP(log) { result in
            success(result)
        }
    }
    fileprivate func sendHTTP(_ log: LoggerData, success: @escaping (Bool)->Void) {
        let encoder = JSONEncoder()
        guard let payload = try? encoder.encode(log) else {
            print("Error with the payload : \(log.sourceFile):\(log.lineNumber)")
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: server.appendingPathComponent("logger"))
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let sem = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request) { data, response, error in
            // TODO explore some debugging?
            success(error == nil)
            sem.signal()
        }
        task.resume()
        sem.wait()
    }
}
