/*
 MIT License
 
 Original idea/implementation
 Copyright (c) 2017 Mladen_K
 
 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import Foundation
import SwiftLoggerCommon

extension SwiftLogger {
    /// Logs a debug level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func debug(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        d(source: source, line: line, function: function, data: data, fileExtension: fileExtension, target: target)
    }
    /// Logs a debug level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func d(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = data, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .DEBUG,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logData: message,
                             dataExtension: fileExtension)
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
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func info(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        i(source: source, line: line, function: function, data: data, fileExtension: fileExtension, target: target)
    }
    /// Logs an info level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func i(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = data, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .INFO,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logData: message,
                             dataExtension: fileExtension)
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
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func warning(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        w(source: source, line: line, function: function, data: data, fileExtension: fileExtension, target: target)
    }
    /// Logs a warning level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func w(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = data, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .WARNING,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logData: message,
                             dataExtension: fileExtension)
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
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func error(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        e(source: source, line: line, function: function, data: data, fileExtension: fileExtension, target: target)
    }
    /// Logs an error level message
    /// - parameters:
    ///   - source: the file the message is originating from (defaults to the current file)
    ///   - line: the line the message is originating from (defaults to the current line)
    ///   - function: the function the message is originating from (defaults to the current function)
    ///   - data: the message to be logged (nil is accepted but will be ignored)
    ///   - fileExtension: the extension of the file if it is to be written to disk
    ///   - target: determines if the message is to be displayed, written to file or both (default both)
    public static func e(source: String = #file, line: Int = #line, function: String = #function, data: Data? = nil, fileExtension: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = data, let instance = sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .ERROR,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logData: message,
                             dataExtension: fileExtension)
        instance.send(log) { result in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
}
