//
//  LoggerUtils.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class LoggerUtils {
    class func getNextSubsystem(subsystem: String, parentSubsystem: String) -> String? {
        let parentSubsystemWithSeparator = parentSubsystem + Logger.nameSeparator
        let subsystemWithoutParent = subsystem.deletingPrefix(parentSubsystemWithSeparator)

        guard parentSubsystemWithSeparator != subsystemWithoutParent,
            let nextSubsystemSection = subsystemWithoutParent.split(separator: "/").first else {
            return nil
        }
        let subsystemToSearch = parentSubsystemWithSeparator + nextSubsystemSection
        return subsystemToSearch
    }
}



 
