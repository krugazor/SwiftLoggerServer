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


// logger data model
struct LoggerData: Codable {
    let appName: String
    let logType: String
    let logTarget: String
    let sourceFile: String
    let lineNumber: Int
    let function: String
    let logText: String
}

// api response data
struct Result: Codable {
    let status: String
    let message: String
}


// logger handler is used to output data to either terminal or data file
func loggerHandler(loggerData: LoggerData, respondWith: @escaping (Result?, RequestError?) -> Void ) -> Void {

    //
    // set unique color for each type of log message
    //
    // defautl terminal output color
    var messageColor: String = "\u{001B}[0;32m"

    // colors for different log types
    switch loggerData.logType {
    case "DEBUG":
        messageColor = "\u{001B}[0;36m"
    case "INFO":
        messageColor = "\u{001B}[0;37m"
    case "WARNING":
        messageColor = "\u{001B}[0;33m"
    case "ERROR":
        messageColor = "\u{001B}[0;31m"
    default:
        respondWith(nil, .internalServerError)
        break
    }


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


    //
    // define output line
    //

    let outputLineForTerminal = String(format: "\(messageColor)***** \(loggerData.logType) ***** APP: \(loggerData.appName) ***** \(timeStamp) ***** SOURCE: \(loggerData.sourceFile) ***** METHOD: \(loggerData.function) ***** AT LINE: \(loggerData.lineNumber) ***** >>> \(loggerData.logText)")
    let outputLineForFile = String(format: "***** \(loggerData.logType) ***** APP: \(loggerData.appName) ***** \(timeStamp) ***** SOURCE: \(loggerData.sourceFile) ***** METHOD: \(loggerData.function) ***** AT LINE: \(loggerData.lineNumber) ***** >>> \(loggerData.logText)")

    // terminal output
    func outputToTerminal() {
        print(outputLineForTerminal)
    }

    // file & terminal output
    func outputToFile() {

        // assign calendar data to appName for filename
        let filename = loggerData.appName + "-" + String(year) + "-" + String(month) + "-" + String(day) + ".log"

        // new line character should be added after each log
        let logString = outputLineForFile + "\n"

        // get data object to be written in a log file
        let logData = logString.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // get current application path and define fileURL
        let fileManager = FileManager.default
        let directory = fileManager.currentDirectoryPath + "/data"

        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename, isDirectory: false)

        // check if logFileTargetDirectory exists and create one if neccessary
        if !FileManager.default.fileExists(atPath: "data") {

            do {
                try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
                respondWith(nil, .internalServerError)
            }
        }

        // check file existance at target directory and store logger data line
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(logData)
                fileHandle.closeFile()
            } catch {
                print(error)
                respondWith(nil, .internalServerError)
            }
        } else {
            // initial file writing (if file is empty)
            do {
                try logString.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                respondWith(nil, .internalServerError)
                print(error)
            }
        }
    }


    // output target "file" or "both" has to be explicitly stated, othewise, terminal output will be implemented
    switch loggerData.logTarget {
    case "file":
        outputToFile()
    case "both":
        outputToFile()
        outputToTerminal()
    default:
        outputToTerminal()
    }

    let result = Result(status: "OK", message: "Data Logged Successfully")

    respondWith(result, nil)

}
