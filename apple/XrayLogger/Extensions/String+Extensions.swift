//
//  String+Extensions.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        return String(dropFirst(prefix.count))
    }

    func retrieveParentSubsystemPath() -> String? {
        guard let lastSeparatorIndex = self.lastIndex(of: "/") else {
            return nil
        }

        let parentSubsystem = String(self[..<lastSeparatorIndex])
        return parentSubsystem
    }
    
    public var currentChildSubsystem: String {
        guard let lastSeparatorIndex = self.lastIndex(of: "/") else {
            return self
        }

        let currentChildSubsystem = String(self[self.index(after: lastSeparatorIndex)...])
        return currentChildSubsystem
    }
    
    public var subsystemWithoutAppBundlePrefix: String {
        guard let firstSeparatorIndex = self.firstIndex(of: "/") else {
            return self
        }
        return String(self[self.index(after: firstSeparatorIndex)...])
    }

//    func isSubsystemPathCorrupeted() -> Bool {
//        let regexLiteral = "^(?:[.\\/\\\\ ](?![.\\/\\\\\\n])|[^<>:\"|?*.\\/\\\\ \\n])+$"
//
//        let regex = try! NSRegularExpression(pattern: regexLiteral,
//                                             options: NSRegularExpression.Options.caseInsensitive)
//        let range = NSMakeRange(0, count)
//
//        return regex.numberOfCaptureGroups > 0
//    }
//
//    func removeDuplicationDelimiterOfSubsystemPath() -> String {
//        let regexLiteral = "(\\/)\\1+"
//        let regex = try! NSRegularExpression(pattern: regexLiteral,
//                                             options: NSRegularExpression.Options.caseInsensitive)
//        let range = NSMakeRange(0, count)
//        let retVal = regex.stringByReplacingMatches(in: self,
//                                                    options: [],
//                                                    range: range,
//                                                    withTemplate: "/")
//        return retVal
//    }
}
