//
//  loggerhandlers.swift
//  CloudLogger
//
//  Created by Mladen Kobiljski · https://www.linkedin.com/in/mladen-kobiljski/
//  Copyright © 2017 Craftwell · http://www.craftwell.io
//  MIT License · http://choosealicense.com/licenses/mit/
//
//  Updated by Nicolas Zinovieff
//


import Foundation
import Kitura
import KituraNet
import KituraContracts
import SwiftLoggerCommon

public struct LoggerError : Swift.Error {
    var message: String
}
public protocol LoggerRouterDelegate {
    var writesToFile : Bool { get }
    func logMessage(_ message: LoggerData) throws
}

func timestamp() -> (year: Int, month: Int, day: Int, timestamp: String) {
    // get current date&time
    let currentDateTime = Date()
    
    // initialize the date formatter and set the style
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.dateStyle = .medium
    
    
    // calendar is used to create unique filename each day for logged data
    let calendar = Calendar.current
    
    let year = calendar.component(.year, from: currentDateTime)
    let month = calendar.component(.month, from: currentDateTime)
    let day = calendar.component(.day, from: currentDateTime)
    
    // get the date time String from the date object
    let timeStamp = formatter.string(from: currentDateTime)
    
    return (year, month, day, timeStamp)
}

func truncateData(_ data: Data?, maxLength: Int = 20) -> String {
    guard let data = data else { return "NO DATA" }
    
    var output = ""
    for i in 0..<min(maxLength, data.count) {
        if output.count > 0 { output += " " }
        output += String(format: "%02hhX", data[i] )
    }
    
    return output
}

public class ConsoleLogger : LoggerRouterDelegate {
    public var writesToFile: Bool { return false }
    
    public func logMessage(_ loggerData : LoggerData) throws {
        let (_, _, _, timeStamp) = timestamp()
        //
        // set unique color for each type of log message
        //
        // defautl terminal output color
        var messageColor: String = "\u{001B}[0;32m"
        
        // colors for different log types
        switch loggerData.logType {
        case .DEBUG:
            messageColor = "\u{001B}[0;36m"
        case .INFO:
            messageColor = "\u{001B}[0;37m"
        case .WARNING:
            messageColor = "\u{001B}[0;33m"
        case .ERROR:
            messageColor = "\u{001B}[0;31m"
        }
        
        let text = loggerData.logText ?? truncateData(loggerData.logData)
        
        let outputLineForTerminal = String(format: "\(messageColor)***** \(loggerData.logType) ***** APP: \(loggerData.appName) ***** \(timeStamp) ***** SOURCE: \(loggerData.sourceFile) ***** METHOD: \(loggerData.function) ***** AT LINE: \(loggerData.lineNumber) ***** >>> \(text)")
        print(outputLineForTerminal)
    }
}

public class FileLogger : LoggerRouterDelegate {
    public var writesToFile: Bool { return true }
    // file  output
    private var outputDirectory : String

    public init(_ dir: String) {
        outputDirectory = dir
    }
    
    public func logMessage(_ loggerData : LoggerData) throws {
        
        // get current application path and define fileURL
        let directory = outputDirectory
                
        // check if logFileTargetDirectory exists and create one if neccessary
        if !FileManager.default.fileExists(atPath: "data") {
            
            do {
                try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                throw LoggerError(message: "Could not create directory \(directory)")
            }
        }

        let (year, month, day, timeStamp) = timestamp()
        
        let text : String
        let datafilename : String
        if let log = loggerData.logText { text = log ; datafilename = "" }
        else if let log = loggerData.logData {
            datafilename = "data-\(loggerData.appName)-\(Date().timeIntervalSince1970).\(loggerData.logDataExt ?? "bin")"
            let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(datafilename, isDirectory: false)
            do {
                try log.write(to: fileURL)
            } catch {
                print(error)
                throw LoggerError(message: "Could not write data to \(fileURL)")
            }
            text = "file: \(datafilename)"
        } else {
            datafilename = ""
            text = "NO DATA"
        }
        
        let outputLineForFile = String(format: "***** \(loggerData.logType) ***** APP: \(loggerData.appName) ***** \(timeStamp) ***** SOURCE: \(loggerData.sourceFile) ***** METHOD: \(loggerData.function) ***** AT LINE: \(loggerData.lineNumber) ***** >>> \(text)")
        
        // assign calendar data to appName for filename
        let filename = loggerData.appName + "-" + String(year) + "-" + String(month) + "-" + String(day) + ".log"
        
        // new line character should be added after each log
        let logString = outputLineForFile + "\n"
        
        // get data object to be written in a log file
        let logData = logString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename, isDirectory: false)

        // check file existance at target directory and store logger data line
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(logData)
                fileHandle.closeFile()
            } catch {
                print(error)
                throw LoggerError(message: "Could not write to \(fileURL)")
            }
        } else {
            // initial file writing (if file is empty)
            do {
                try logString.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print(error)
                throw LoggerError(message: "Could not write to \(fileURL)")
            }
        }
    }
}

public class LoggerRouter {
    public private(set) var router : Router
    public var logDelegates : [LoggerRouterDelegate] = []
    
    init(dataDir: String? = nil, logToFile: Bool = false, logToUI: Bool = true) {
        let _router = Router()
        router = _router
        
        if logToUI {
            logDelegates.append(ConsoleLogger())
        }
        
        if logToFile {
            let outputDirectory : String
            if let dataDir = dataDir {
                outputDirectory = dataDir
            } else {
                outputDirectory = FileManager.default.currentDirectoryPath + "/data"
            }
            logDelegates.append(FileLogger(outputDirectory))
        }
        
        defer {
            // SwiftLogger Backend Route (define handler)
            _router.post("/logger", handler: loggerHandler)
            
            _router.get("/") { req, res, next in
                res.status(.notFound)
                next()
            }
        }
    }
    
    public func addLogger(_ l: LoggerRouterDelegate) {
        logDelegates.append(l)
    }
    
    public static func httpLoggerRouter(dataDir: String? = nil, logToFile: Bool = false, logToUI: Bool = true) -> LoggerRouter {
        return LoggerRouter(dataDir: dataDir, logToFile: logToFile, logToUI: logToUI)
    }
    
    public static func networkLoggerRouter(name: String,
                                           passcode: String = LoggerData.defaultPasscode,
                                           delegate: PeerConnectionDelegate? = nil,
                                           dataDir: String? = nil,
                                           logToFile: Bool = false,
                                           logToUI: Bool = true) -> LoggerRouter {
        return NetworkLoggerRouter(name: name,
                                   passcode: passcode,
                                   delegate: delegate,
                                   dataDir: dataDir,
                                   logToFile: logToFile,
                                   logToUI: logToUI)
    }
    
    @discardableResult func logToDelegates(loggerData: LoggerData) -> [Swift.Error] {
        var errors : [Swift.Error] = []
        
        // output target "file" or "both" has to be explicitly stated, othewise, terminal output will be implemented
        let files = logDelegates.filter({ $0.writesToFile })
        let noFiles = logDelegates.filter({ !$0.writesToFile })
        switch loggerData.logTarget {
        case .file:
            for logd in files {
                do {
                    try logd.logMessage(loggerData)
                } catch {
                    if let err = error as? LoggerError {
                        print(err.message)
                    }
                    errors.append(error)
                }
            }
        case .both:
            for logd in logDelegates {
                do {
                    try logd.logMessage(loggerData)
                } catch {
                    if let err = error as? LoggerError {
                        print(err.message)
                    }
                    errors.append(error)
                }
            }
        default:
            for logd in noFiles {
                do {
                    try logd.logMessage(loggerData)
                } catch {
                    if let err = error as? LoggerError {
                        print(err.message)
                    }
                    errors.append(error)
                }
            }
        }

        return errors
    }
    
    // logger handler is used to output data to either terminal or data file
    func loggerHandler(loggerData: LoggerData, respondWith: @escaping (LoggerResult?, RequestError?) -> Void) -> Void {
        let errors : [Swift.Error] = logToDelegates(loggerData: loggerData)

        let finalError = !errors.isEmpty
        if !finalError {
            let result = LoggerResult(status: .ok, message: "Data Logged Successfully")
            respondWith(result, nil)
        } else {
            respondWith(nil, .internalServerError)
        }
        
    }
    

    
    
}

