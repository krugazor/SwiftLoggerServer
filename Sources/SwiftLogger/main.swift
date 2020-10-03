//
//  main.swift
//  Swift Logger Server Application
//
//  Created by Mladen Kobiljski · https://www.linkedin.com/in/mladen-kobiljski/
//  Copyright © 2017 Craftwell · http://www.craftwell.io
//  MIT License · http://choosealicense.com/licenses/mit/
//
//  Updated by Nicolas Zinovieff
//


// import declarations
import Foundation
import Kitura
import KituraNet



// create a new router
let router = Router()


// SwiftLogger Backend Route (define handler)
router.post("/logger", handler: loggerHandler)


// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)


// start the Kitura runloop (this call never returns)
Kitura.run()

