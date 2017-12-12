![](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat)


# Swift Logger Server

Server Side of Swift Logger API.

Simple Logging API used to collect log messages from different sources using the HTTP .post requests and display them to the console as differently colored strings, or store them to the log files for further examination. Swift Logger Server can either be deployed to a remote server or run locally to listen for a log messages on the particular port (defaults to 8080).
The preferred way of starting the Swift Logger Server application is by running a Docker container from the image: [mladenk/swift-logger](https://hub.docker.com/r/mladenk/swift-logger/) which already contains both the source files and compiled binaries. By executing next command from directory on server that will hold data:

```docker
docker run -itv $(pwd):/SwiftLogger/data -w /SwiftLogger  --name logger -p 8080:8080 mladenk/swift-logger /SwiftLogger/.build/debug/SwiftLogger
```

docker will pull the required image, spin-up a new container named logger and run SwiftLogger API that listens for requests on port 8080.

Swift Logger API has only one endpoint - /logger that expects request with the header [Content-Type: application/json] and body of a request containing JSON representation of following struct object:

```swift
struct LoggerData: Codable {
    let appName: String
    let logType: String
    let logTarget: String
    let sourceFile: String
    let lineNumber: Int
    let function: String
    let logText: String
}
```

Example JSON representation of request body:
```json
{
    "appName": "My Application",
    "logType": "DEBUG",                 
    "logTarget": "terminal",
    "sourceFile": "main.swift",
    "lineNumber": 10,
    "function": "errorHandler()",
    "logText": "Some arbitrary message"
}
```

Available values for logType key are: "DEBUG", "INFO", "WARNING" & "ERROR"
Available values for logTarget key are: "terminal", "file", or "both"

By using: [Swift Logger Client](https://github.com/Mladen-K/Swift-Logger-Client), all fields except type and message are automatically configured and populated.

If logger API is deployed on a remote server, it is best to configure it behind an NGINX reverse proxy that will pass all the requests made to logger.your_server_ip_address to desired 8080 port.

Log data files are by default stored inside /SwiftLogger/data directory. When running logger application using above mentioned Docker command, it will automatically map internal container /SwiftLogger/data directory to the one from which the container is started.

More information about server configuration is to be found on: [Logging Events Using Swift Cloud Logger](http://craftwell.io/logging-events-using-swift-cloud-logger/)


## Prerequisites

### Swift
* Open Source Swift 4.0.0 or higher

### macOS
* macOS Sierra 10.12.6 or higher
* Xcode Version 9.0 (9A325) or higher

### Linux
* Ubuntu 16.04 & 16.10 (only tested on 16.04)


## License
[MIT Licence](https://github.com/Mladen-K/Swift-Logger-Server/blob/master/LICENSE)
