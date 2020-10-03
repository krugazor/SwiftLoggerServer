//
//  main.swift

import Foundation
import SwiftLogger
import Kitura
import ArgumentParser

struct SwiftLoggerServer : ParsableCommand {
    @Option(name: .shortAndLong, help: "The port to run on")
    var port : Int?
    
    @Option(name: .shortAndLong, help: "The path of the directory to write logs to")
    var dataDir: String?
    
    mutating func run() throws {
        let router = LoggerRouter(dataDir: dataDir)
        
        // Add an HTTP server and connect it to the router
        Kitura.addHTTPServer(onPort: (port ?? 8080), with: router.router)
        
        
        // start the Kitura runloop (this call never returns)
        Kitura.run()
    }
}

SwiftLoggerServer.main()
