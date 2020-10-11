/*
 MIT License
 
 Original idea/implementation
 Copyright (c) 2017 Mladen_K
 
 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import Foundation

/// logger data model
public struct LoggerData : Codable {
    /// Default passcode for the lazy (or the developer)
    public static let defaultPasscode = "SwiftLoggerPasscode"
    /// Standard log types
    public enum LoggerType : String, Codable {
        /// Debug level message
        case DEBUG
        /// Info level message
        case INFO
        /// Warning level message
        case WARNING
        /// Error level message
        case ERROR
    }
    /// Messages can be directed to the console, a file, or both
    public enum LoggerTarget : String, Codable {
        /// Write log to disk
        case file
        /// Show log in UI (including terminal)
        case terminal
        /// Show and write
        case both
    }
    
    /// App name, used for naming the file too
    public let appName: String
    /// Message level
    public let logType: LoggerType
    /// Message target
    public let logTarget: LoggerTarget
    /// Source file of origin
    public let sourceFile: String
    /// Source line of origin
    public let lineNumber: Int
    /// Source function of origin
    public let function: String
    /// Text of the message
    public let logText: String?
    /// Data of the message (eg image, sound, etc)
    public let logData: Data?
    /// File extension to use when writing that data to disk
    public let logDataExt: String?
    /// Date of the log, defaults the date of creation
    public var logDate: Date = Date()
    
    /// Text message initializer
    /// - parameters:
    ///   - appName: App name, used for naming the file too
    ///   - logType: Message level
    ///   - logTarget: Message target
    ///   - sourceFile: Source file of origin
    ///   - lineNumber: Source line of origin
    ///   - function: Source function of origin
    ///   - logText: Text of the message
    public init(
        appName apn: String,
        logType lty: LoggerType,
        logTarget lta: LoggerTarget,
        sourceFile sof: String,
        lineNumber lin: Int,
        function fun: String,
        logText text: String
    ) {
        appName = apn
        logType = lty
        logTarget = lta
        sourceFile = sof
        lineNumber = lin
        function = fun
        logText = text
        logData = nil
        logDataExt = nil
    }
    
    /// Data message initializer
    /// - parameters:
    ///   - appName: App name, used for naming the file too
    ///   - logType: Message level
    ///   - logTarget: Message target
    ///   - sourceFile: Source file of origin
    ///   - lineNumber: Source line of origin
    ///   - function: Source function of origin
    ///   - logData: Data of the message (eg image, sound, etc)
    ///   - dataExtension: File extension to use when writing that data to disk
    public init(
        appName apn: String,
        logType lty: LoggerType,
        logTarget lta: LoggerTarget,
        sourceFile sof: String,
        lineNumber lin: Int,
        function fun: String,
        logData data: Data,
        dataExtension ext: String?
    ) {
        appName = apn
        logType = lty
        logTarget = lta
        sourceFile = sof
        lineNumber = lin
        function = fun
        logText = nil
        logData = data
        logDataExt = ext
    }
    
}

/// api response data (HTTP only)
public struct LoggerResult : Codable {
    /// Status of the response (on top of the http error code)
    public enum LoggerStatus : String, Codable {
        case ok = "OK"
        case error = "ERROR"
    }
    public let status: LoggerStatus
    public let message: String
    
    public init(status sts: LoggerStatus, message msg: String) {
        status = sts
        message = msg
    }
}
