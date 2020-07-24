//
//  LoggerNavigationController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/24/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import UIKit
public class LoggerNavigationController: UINavigationController {
    public static func loggerNavigationController() -> UINavigationController {
        let loggerViewController = LoggerViewController(nibName: "LoggerViewController",
                                                        bundle: nil)
        return UINavigationController(rootViewController: loggerViewController)
    }
}
