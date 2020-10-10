import Foundation
import SwiftLoggerCommon
#if os(Linux)
import Dispatch
import FoundationNetworking
#endif

public class SwiftLogger {
    public static func setupForHTTP(_ url: URL, appName: String) {
        _sharedInstance = SwiftLogger(url, appName: appName)
    }
    
    public static func d(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = _sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .DEBUG,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { (result) in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    public static func i(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = _sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .INFO,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { (result) in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    public static func w(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = _sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .WARNING,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { (result) in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    
    public static func e(source: String = #file, line: Int = #line, function: String = #function, message: String? = nil, target: LoggerData.LoggerTarget = .both) {
        guard let message = message, let instance = _sharedInstance else { return }
        let log = LoggerData(appName: instance.appName,
                             logType: .ERROR,
                             logTarget: target,
                             sourceFile: source,
                             lineNumber: line,
                             function: function,
                             logText: message)
        instance.send(log) { (result) in
            if instance.debug {
                print("Submitted log: \(result)")
            }
        }
    }
    

    // MARK: -
    fileprivate var appName : String
    fileprivate var server : URL
    public var debug : Bool = false
    
    init(_ url: URL, appName n: String) { // HTTP client
        server = url
        appName = n
    }
    
    static var _sharedInstance : SwiftLogger?
    
    // for overriding purposes
    open func send(_ log: LoggerData, success: @escaping (Bool)->Void) {
        sendHTTP(log) { (result) in
            success(result)
        }
    }
    fileprivate func sendHTTP(_ log: LoggerData, success: @escaping (Bool)->Void) {
        let encoder = JSONEncoder()
        guard let payload = try? encoder.encode(log) else {
            print("Error with the payload : \(log.sourceFile):\(log.lineNumber)")
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: server.appendingPathComponent("logger"))
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = payload
        
        let sem = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: request) { data, response, error in
            // TODO explore some debugging?
            success(error == nil)
            sem.signal()
        }
        task.resume()
        sem.wait()
    }
}
