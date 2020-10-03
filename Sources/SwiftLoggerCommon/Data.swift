
import Foundation

// logger data model
public struct LoggerData : Codable {
    public enum LoggerType : String, Codable {
        case DEBUG
        case INFO
        case WARNING
        case ERROR
    }
    public enum LoggerTarget : String, Codable {
        case file
        case terminal
        case both
    }

    public let appName: String
    public let logType: LoggerType
    public let logTarget: LoggerTarget
    public let sourceFile: String
    public let lineNumber: Int
    public let function: String
    public let logText: String?
    public let logData: Data?
    public let logDataExt: String?
    
    public init(
        appName an: String,
        logType lty: LoggerType,
        logTarget lta: LoggerTarget,
        sourceFile sf: String,
        lineNumber ln: Int,
        function fn: String,
        logText text: String
    ) {
        appName = an
        logType = lty
        logTarget = lta
        sourceFile = sf
        lineNumber = ln
        function = fn
        logText = text
        logData = nil
        logDataExt = nil
    }
    
    public init(
        appName an: String,
        logType lty: LoggerType,
        logTarget lta: LoggerTarget,
        sourceFile sf: String,
        lineNumber ln: Int,
        function fn: String,
        logData data: Data,
        dataExtension ext: String
    ) {
        appName = an
        logType = lty
        logTarget = lta
        sourceFile = sf
        lineNumber = ln
        function = fn
        logText = nil
        logData = data
        logDataExt = ext
    }

}

// api response data
public struct LoggerResult : Codable {
    public enum LoggerStatus : String, Codable {
        case ok = "OK"
        case error = "ERROR"
    }
    public let status: LoggerStatus
    public let message: String
    
    public init(status s: LoggerStatus, message m: String) {
        status = s
        message = m
    }
}

