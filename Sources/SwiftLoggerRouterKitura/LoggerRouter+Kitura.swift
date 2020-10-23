/*
 MIT License
 
 Original idea/implementation
 Copyright (c) 2017 Mladen_K
 
 Adapted and rewritten
 Copyright (c) 2020 Zino
 */

import Foundation
import SwiftLoggerCommon
import SwiftLoggerRouterBase
import Kitura
import KituraNet
import KituraContracts

/// `Network.framework` logger server
public class KituraLoggerRouter : LoggerRouter {
    /// The Kitura router
    public private(set) var router : Router

    public override init(dataDir: String? = nil, logToFile: Bool = false, logToUI: Bool = true) {
        let tmpRouter = Router()
        router = tmpRouter
        
        super.init(dataDir: dataDir, logToFile: logToFile, logToUI: logToUI)

        defer {
            // SwiftLogger Backend Route (define handler)
            tmpRouter.post("/logger", handler: loggerHandler)
            
            tmpRouter.get("/") { req, res, next in
                res.status(.notFound)
                next()
            }
        }
    }
    
    
    // logger handler is used to output data to either terminal or data file
    func loggerHandler(loggerData: LoggerData, respondWith: @escaping (LoggerResult?, RequestError?) -> Void) {
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
