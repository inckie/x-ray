//
//  AppDelegate.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        XrayLogger.sharedInstance.addSink(identifier: "test",
                                          sink: Console(logType: .os_log))
        let rootLogger = Logger.getLogger(for: "com.test.anton")
        rootLogger?.context["test_context_data"] = "context_value"

        rootLogger?.logEvent(logLevel: .error,
                             message: "Test %@, %@, %@",
                             category: "category",
                             data: ["data_key": "data_value"],
                             exception: nil,
                             args: "33", ["1", "2", "3"], ["myKey": ["A", "B", "C"]])

        return true
    }

    // MARK: UISceneSession Lifecycle
}
