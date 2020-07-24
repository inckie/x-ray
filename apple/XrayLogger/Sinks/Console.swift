//
//  Console.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import os

public enum LogType: NSInteger {
    case print
    case os_log
}

public class Console: BaseSink {
    var logType: LogType = .os_log

    public init(logType: LogType) {
        self.logType = logType
        super.init()
    }

    public override var asynchronously: Bool {
        get {
            return false
        }
        set {
        }
    }

    public override func log(event: Event) {
        if logType == .os_log {
            logOsLog(event: event)
        } else {
            logPrint(event: event)
        }
    }

    private func logPrint(event: Event) {
        let message = formatter?.format(event: event) ?? event.message

        print(message)
    }

    private func logOsLog(event: Event) {
        let model_log = OSLog(subsystem: event.subsystem,
                              category: event.category)
        let message = formatter?.format(event: event) ?? event.message
        let level = osLogLevelMapper(logLevel: event.level)
        os_log("%{public}@", log: model_log, type: level, message)
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
