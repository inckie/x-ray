//
//  AppDelegate.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let log = SwiftyBeaver.self

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        XrayLogger.sharedInstance.addSink(identifier: "console",
                                          sink: Console(logType: .print))
        XrayLogger.sharedInstance.addSink(identifier: "file",
                                            sink: File())
        let rootLogger = Logger.getLogger(for: "com.test.anton")
        rootLogger?.context["test_context_data"] = "context_value"

        rootLogger?.logEvent(logLevel: .error,
                             message: "My error logger",
                             category: "category",
                             data: ["data_key": "data_value"],
                             exception: nil)
        rootLogger?.logEvent(logLevel: .debug,
                              message: "Debug thing",
                              category: "category",
                              data: ["data_key": "data_value"],
                              exception: nil)
        
        rootLogger?.logEvent(logLevel: .info,
                                   message: "Long info message that describe problmeatic pieces in the code. Just to make it a bit bigger to undestand if we can make autoresizable cell and it will looks good",
                                   category: "category",
                                   data: ["data_key": "data_value"],
                                   exception: nil)
        
        rootLogger?.logEvent(logLevel: .verbose,
                                     message: "Long info message that describe problmeatic pieces in the code. Just to make it a bit bigger to undestand if we can make autoresizable cell and it will looks good",
                                     category: "category",
                                     data: ["data_key": "data_value"],
                                     exception: nil)
        
        rootLogger?.logEvent(logLevel: .warning,
                                     message: "Long info message that describe problmeatic pieces in the code. Just to make it a bit bigger to undestand if we can make autoresizable cell and it will looks good",
                                     category: "category",
                                     data: ["data_key": "data_value"],
                                     exception: nil)
        


        
        let console = ConsoleDestination()
        let file = FileDestination()// log to Xcode Console
//        console.format = "$DHH:mm:ss$d $L $M"

        log.addDestination(console)
        log.addDestination(file)

        log.verbose("not so important")  // prio 1, VERBOSE in silver
        log.debug("something to debug")  // prio 2, DEBUG in green
        log.info("a nice information")   // prio 3, INFO in blue
        log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
        log.error("ouch, an error did occur!")

        return true
    }

}
