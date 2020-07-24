//
//  AppDelegate.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import LoggerInfo
import Reporter
import SwiftyBeaver
import UIKit
import XrayLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let log = SwiftyBeaver.self

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        XrayLogger.sharedInstance.addSink(identifier: "console",
                                          sink: Console(logType: .print))
        let fileJSONSink = FileJSON()
        XrayLogger.sharedInstance.addSink(identifier: "fileJSON",
                                          sink: FileJSON())
        let inMemorySink = InMemory()
        XrayLogger.sharedInstance.addSink(identifier: "inMemorySink",
                                          sink: inMemorySink)
        Reporter.setDefaultData(emails: ["a.kononenko@applicaster.com"],
                                url: fileJSONSink.fileURL,
                                contexts: ["MyAppData1": "SomeValue", "MyAppData2": "SomeValue2"])

        let rootLogger = Logger.getLogger(for: "quickbrick/rn_plugin/player/player_controls/airplay_button")
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
                             message: "Long info message that describe problmeatic pieces in the code. Just to make it a bit bigger to undestand if we can make autoresizable cell and it will looks good Long info message that describe problmeatic pieces in the code. Just to make it a bit bigger to undestand if we can make autoresizable cell and it will looks good",
                             category: "category",
                             data: ["data_key": "data_value"],
                             exception: nil)

        let console = ConsoleDestination()
        let file = FileDestination() // log to Xcode Console
//        console.format = "$DHH:mm:ss$d $L $M"

        log.addDestination(console)
        log.addDestination(file)

        log.verbose("not so important") // prio 1, VERBOSE in silver
        log.debug("something to debug") // prio 2, DEBUG in green
        log.info("a nice information") // prio 3, INFO in blue
        log.warning("oh no, that won’t be good") // prio 4, WARNING in yellow
        log.error("ouch, an error did occur!")

        let gesture = GTGestureRecognizer(target: self, action: #selector(presentLoggerInfo))
        window?.addGestureRecognizer(gesture)
        return true
    }

    @objc func presentLoggerInfo() {
        let loggerNavController = LoggerNavigationController.loggerNavigationController()
        UIApplication.shared.windows.first?.rootViewController?.present(loggerNavController,
                                                                        animated: true,
                                                                        completion: nil)
    }
}
