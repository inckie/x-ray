//
//  DataSourceHelper.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import xray
class DataSourceHelper {
    var verbose: [Event] = []
    var debug: [Event] = []
    var info: [Event] = []
    var warning: [Event] = []
    var error: [Event] = []

    var currentDataSource: [Event] = []

    var currentDisplayLog: Set<LogLevel> = [LogLevel.verbose,
                                            LogLevel.debug,
                                            LogLevel.info,
                                            LogLevel.warning,
                                            LogLevel.error]

    func addEvent(event: Event) -> [Event] {
        switch event.level {
        case .verbose:
            verbose.append(event)
        case .debug:
            debug.append(event)
        case .info:
            info.append(event)
        case .warning:
            warning.append(event)
        case .error:
            error.append(event)
        }

        if isCurrentlyDisplayedType(event: event) {
            currentDataSource.append(event)
        }
        return currentDataSource
    }

    func isCurrentlyDisplayedType(event: Event) -> Bool {
        return currentDisplayLog.contains(event.level)
    }

    func getDataSource(displayLog: Set<LogLevel>) -> [Event] {
        if displayLog == currentDisplayLog {
            return currentDataSource
        }

        var newDataSource: [Event] = []

        for logLevel in displayLog {
            switch logLevel {
            case .verbose:
                newDataSource += verbose
            case .debug:
                newDataSource += debug
            case .info:
                newDataSource += info
            case .warning:
                newDataSource += warning
            case .error:
                newDataSource += error
            }
        }

        let sortedResult = sortByDate(events: newDataSource)
        currentDataSource = sortedResult
        currentDisplayLog = displayLog
        return sortedResult
    }

    func sortByDate(events: [Event]) -> [Event] {
        let result: [Event] = events.sorted { (event1, event2) -> Bool in
            event1.timestamp < event2.timestamp
        }

        return result
    }
}
