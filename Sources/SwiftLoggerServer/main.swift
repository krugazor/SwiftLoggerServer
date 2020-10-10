//
//  main.swift

import Foundation
import SwiftLogger
import Kitura
import ArgumentParser
import SwiftLoggerCommon

let group = DispatchGroup()

struct SwiftLoggerServer : ParsableCommand {
    @Option(name: .shortAndLong, help: "The port to run on (defaults to 8080)")
    var port : Int?
    
    @Option(name: .shortAndLong, help: "The path of the directory to write logs to (defaults to ./data)")
    var dataDir: String?
    
    @Option(name: .shortAndLong, help: "Writes log to disk")
    var fileLogging: Bool = false
    
    @Option(name: .shortAndLong, help: "Writes log to UI")
    var uiLogging: Bool = true
    
    #if !os(Linux)
    @Argument(help: "The network mode to run (http|network). Please be aware that network mode is only available on Apple platforms")
    var mode : String
    #else
    private var mode = "http"
    #endif
    
    private enum ModeType : String {
        case http = "http"
        case network = "network"
    }
    
    mutating func run() throws {
        guard let chosen = ModeType(rawValue: mode) else {
            print("Please choose between 'http' and 'network' modes")
            return
        }
        
        switch chosen {
        case .http:
            let router = LoggerRouter.httpLoggerRouter(dataDir: dataDir)
        
            // Add an HTTP server and connect it to the router
            Kitura.addHTTPServer(onPort: (port ?? 8080), with: router.router)
            
            print("Started listening on port \(port ?? 8080)")
            print("***")
            
            // start the Kitura runloop (this call never returns)
            Kitura.run()
        case .network:
            let router = LoggerRouter.networkLoggerRouter(name: "SwiftLogger Server",
                                                          passcode: LoggerData.defaultPasscode,
                                                          delegate: nil,
                                                          dataDir: dataDir,
                                                          logToFile: fileLogging,
                                                          logToUI: uiLogging)
            
            group.enter()
            _ = group.wait(timeout: DispatchTime.distantFuture)
        }
    }
}

SwiftLoggerServer.main()
