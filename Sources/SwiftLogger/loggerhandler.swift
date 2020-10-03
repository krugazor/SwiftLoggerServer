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

public class LoggerRouter {
    public private(set) var router : Router
    private var logToFile : Bool = false
    private var logToConsole : Bool = true
    private var outputDirectory : String
    
    public init(dataDir: String?) {
        let _router = Router()
        router = _router
        
        if let dataDir = dataDir {
            outputDirectory = dataDir
        } else {
            outputDirectory = FileManager.default.currentDirectoryPath + "/data"
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
    // logger handler is used to output data to either terminal or data file
    func loggerHandler(loggerData: LoggerData, respondWith: @escaping (LoggerResult?, RequestError?) -> Void) -> Void {
        var errors : [RequestError] = []
        
        // output target "file" or "both" has to be explicitly stated, othewise, terminal output will be implemented
        switch loggerData.logTarget {
        case .file:
             if let error = outputToFile(loggerData: loggerData) { errors.append(error) }
        case .both:
            if let error = outputToFile(loggerData: loggerData) { errors.append(error) }
            if let error = outputToTerminal(loggerData: loggerData) { errors.append(error) }
        default:
            if let error = outputToTerminal(loggerData: loggerData) { errors.append(error) }
        }
        
        let finalError = errors.contains(.internalServerError)
        if !finalError {
            let result = LoggerResult(status: .ok, message: "Data Logged Successfully")
            respondWith(result, nil)
        } else {
            respondWith(nil, .internalServerError)
        }
        
    }
    
    // terminal output
    func truncateData(_ data: Data?, maxLength: Int = 20) -> String {
        guard let data = data else { return "NO DATA" }
        
        var output = ""
        for i in 0..<min(maxLength, data.count) {
            if output.count > 0 { output += " " }
            output += String(format: "%02hhX", data[i] )
        }
        
        return output
    }
    
    func outputToTerminal(loggerData : LoggerData) -> RequestError? {
        guard logToConsole else { return .internalServerError }
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
        default:
            return .internalServerError
        }
        
        let text = loggerData.logText ?? truncateData(loggerData.logData)
        
        let outputLineForTerminal = String(format: "\(messageColor)***** \(loggerData.logType) ***** APP: \(loggerData.appName) ***** \(timeStamp) ***** SOURCE: \(loggerData.sourceFile) ***** METHOD: \(loggerData.function) ***** AT LINE: \(loggerData.lineNumber) ***** >>> \(text)")
        print(outputLineForTerminal)
        
        return nil
    }
    
    // file & terminal output
    func outputToFile(loggerData : LoggerData)  -> RequestError? {
        guard logToFile else { return .internalServerError }
        
        // get current application path and define fileURL
        let directory = outputDirectory
                
        // check if logFileTargetDirectory exists and create one if neccessary
        if !FileManager.default.fileExists(atPath: "data") {
            
            do {
                try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return .internalServerError
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
                return .internalServerError
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
                return .internalServerError
            }
        } else {
            // initial file writing (if file is empty)
            do {
                try logString.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print(error)
                return .internalServerError
            }
        }
        
        return nil
    }
    
    
}

