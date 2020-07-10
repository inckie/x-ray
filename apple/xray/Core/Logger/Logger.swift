//
//  Logger.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class Logger: NSObject {
    static let rootLogger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                   parent: nil)
    static let nameSeparator = "/"

    public let subsystem: String
    private var children: [String: Logger] = [:]
    weak var parent: Logger?

    let context: [String: Any] = [:]
    // TODO: Make message formatter if needed here

    init(subsystem: String, parent: Logger?) {
        self.subsystem = subsystem
        self.parent = parent
        super.init()
    }

    func logEvent(
        logLevel: LogLevel = .debug,
        message: String,
        category: String? = nil,
        data: [String: Any]? = nil,
        exception: NSException? = nil,
        otherArgs: Any...) {
        EventBuilder.submit(subsystem: subsystem,
                            logLevel: logLevel,
                            category: category,
                            data: data,
                            context: getFullContext(),
                            messageFormatter: nil,
                            message: message,
                            exception: exception,
                            otherArgs: otherArgs)
    }

    func getFullContext() -> [String: Any] {
        var retVal: [String: Any] = [:]
        if let parent = parent {
            retVal.merge(parent.getFullContext()) { _, new in new }
        }
        retVal.merge(context) { _, new in new }
        return context
    }

    static func getLogger(for subsystem: String? = nil) -> Logger {
        guard let subsystem = subsystem else {
            return rootLogger
        }
        if subsystem.hasPrefix(rootLogger.subsystem) {
            return rootLogger.child(for: subsystem)
        }
        let fullSubsystem = rootLogger.subsystem + nameSeparator + subsystem
        return rootLogger.child(for: fullSubsystem)
    }

    func getLogger(for subsystem: String) -> Logger {
        if self.subsystem == subsystem {
            return self
        }
        return child(for: subsystem)
    }

    func child(for subsystem: String) -> Logger {
        if let subsystemToSearch = LoggerUtils.getNextSubsystem(subsystem: subsystem,
                                                                parentSubsystem: self.subsystem) {
            if let searchedItem = children[subsystemToSearch] {
                if searchedItem.subsystem == subsystemToSearch {
                    return searchedItem
                } else {
                    return searchedItem.getLogger(for: subsystem)
                }
            } else {
                let newChild = Logger(subsystem: subsystemToSearch,
                                      parent: self)
                return newChild.getLogger(for: subsystem)
            }

        } else {
            // TODO: Possible nil
        }
        return self
    }
}

