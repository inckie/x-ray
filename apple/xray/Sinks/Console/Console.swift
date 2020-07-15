//
//  Console.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import os

public enum ConsoleType: NSInteger {
    case print
    case os_log
}

public class Console: BaseSink {
    var consoleType: ConsoleType = .os_log

    init(consoleType: ConsoleType) {
        self.consoleType = consoleType
        super.init()
    }

    public override func log(event: Event) {
    }

    private func logPrint(event: Event) {
        let message = formatter?.format(event: event) ?? event.message

        let log = """
                Level: \(event.level.toString())
                Category: \(event.category)
                Subsystem: \(event.subsystem)
                \(message)
        """
        
        print(log)
    }

    private func logOsLog(event: Event) {
        let model_log = OSLog(subsystem: event.subsystem,
                              category: event.category)
        let message = formatter?.format(event: event) ?? event.message
        let level = osLogLevelMapper(logLevel: event.level)
        // TODO: Check if we want to setup it
        os_log(level,
               log: model_log,
               "%{public}%@",
               message)
    }

    private func osLogLevelMapper(logLevel: LogLevel) -> OSLogType {
        switch logLevel {
        case .info:
            return .info
        case .debug:
            return .debug
        case .verbose:
            return .default
        case .warning:
            return .error
        case .error:
            return .fault
        }
    }
}
