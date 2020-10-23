/*
 MIT License
 
 Original idea/implementation
 Copyright (c) 2017 Mladen_K
 
 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import SwiftLoggerCommon
import SwiftLoggerRouterBase
import SwiftLoggerRouterKitura
import SwiftLoggerRouterNetwork

public typealias LoggerRouter = SwiftLoggerRouterBase.LoggerRouter
public extension LoggerRouter {
    /// Starts a new HTTP endpoint for logging (not secure, anyone and anything can log to it)
    /// - parameters:
    ///   - dataDir: the directory to write log files to (if applicable)
    ///   - logToFile: install the default file logger (default: false)
    ///   - logToUI: install the default console logger (default: true)
    /// - returns: The configured server to be used with Kitura
    static func httpLoggerRouter(dataDir: String? = nil, logToFile: Bool = false, logToUI: Bool = true) -> LoggerRouter {
        return LoggerRouter(dataDir: dataDir, logToFile: logToFile, logToUI: logToUI)
    }
    
    #if !os(Linux)
    /// Starts a new `Network.framework` endpoint for logging (kind of secure, traffic at least is encrypted)
    /// Available only on Apple platforms, beginning at Swift 5 (macOS 10.15, iOS
    /// - parameters:
    ///   - dataDir: the directory to write log files to (if applicable)
    ///   - logToFile: install the default file logger (default: false)
    ///   - logToUI: install the default console logger (default: true)
    /// - returns: A configured and started server
    static func networkLoggerRouter(name: String,
                                           passcode: String = LoggerData.defaultPasscode,
                                           delegate: PeerConnectionDelegate? = nil,
                                           dataDir: String? = nil,
                                           logToFile: Bool = false,
                                           logToUI: Bool = true) -> NetworkLoggerRouter {
        return NetworkLoggerRouter(name: name,
                                   passcode: passcode,
                                   delegate: delegate,
                                   dataDir: dataDir,
                                   logToFile: logToFile,
                                   logToUI: logToUI)
    }
    #endif

}
