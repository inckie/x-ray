//
//  NetworkRequestStatusCode.swift
//  XrayLogger
//
//  Created by Alex Zchut on 21/12/2021.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import Foundation

public enum NetworkRequestStatusCode: NSInteger {
    case x000 = 0
    case x200 = 200
    case x300 = 300
    case x400 = 400
    case x500 = 500

    public init?(statusCode: String) {
        let stringValue = "\(statusCode.first ?? "1")00"
        guard let intValue = Int(stringValue),
              let value = NetworkRequestStatusCode(rawValue: intValue) else {
            return nil
        }
        self = value
    }

    public func toString() -> String {
        switch self {
        case .x200:
            return "2xx"
        case .x300:
            return "3xx"
        case .x400:
            return "4xx"
        case .x500:
            return "5xx"
        default:
            return "0"
        }
    }

    public func toColor() -> UIColor {
        switch self {
        case .x200:
            return UIColor(red: 76 / 255, green: 153 / 255, blue: 0 / 255, alpha: 1)
        case .x300:
            return UIColor(red: 153 / 255, green: 153 / 255, blue: 0 / 255, alpha: 1)
        case .x400:
            return UIColor(red: 153 / 255, green: 76 / 255, blue: 0 / 255, alpha: 1)
        case .x500:
            return UIColor(red: 153 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        default:
            return UIColor.white
        }
    }
}
