//
//  LogLevel.swift
//  XrayLogger
//
//  Created by Alex Zchut on 21/12/2021.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import Foundation

public enum LogLevel: NSInteger {
    case verbose
    case debug
    case info
    case warning
    case error

    public func toString() -> String {
        switch self {
        case .verbose:
            return "VERBOSE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }

    public func toColor() -> UIColor {
        switch self {
        case .verbose:
            return UIColor(red: 0 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
        case .debug:
            return UIColor(red: 0 / 255, green: 76 / 255, blue: 153 / 255, alpha: 1)
        case .info:
            return UIColor(red: 153 / 255, green: 153 / 255, blue: 0 / 255, alpha: 1)
        case .warning:
            return UIColor(red: 153 / 255, green: 76 / 255, blue: 0 / 255, alpha: 1)
        case .error:
            return UIColor(red: 153 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        }
    }
}
