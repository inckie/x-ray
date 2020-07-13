//
//  Mapper.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class Mapper {
    private(set) var sinksIdentifiers: Set<String> = []
    private var loggerMapping: [String: [String: SinkFilterProtocol]] = [:]
    func refreshSinks(sinks: [String: SinkProtocol]) {
        sinksIdentifiers = Set(sinks.keys)
    }

    func setFilter(loggerSubsystem: String,
                   sinkIdentifier: String,
                   filter: SinkFilterProtocol?) {
        let mappedSubsystem = loggerMapping[loggerSubsystem]
        if var mappedSubsystem = mappedSubsystem {
            if let filter = filter {
                mappedSubsystem[sinkIdentifier] = filter
            } else {
                mappedSubsystem[sinkIdentifier] = nil
                if mappedSubsystem.isEmpty {
                    loggerMapping[loggerSubsystem] = nil
                }
            }
            return
        }

        guard let filter = filter else {
            return
        }

        loggerMapping[loggerSubsystem] = [sinkIdentifier: filter]
    }

    private func getClosestMapping(loggerSubsystem: String) -> [String: SinkFilterProtocol]? {
        if loggerSubsystem == "" {
            return loggerMapping[""]
        }

        if let mappedSinks = loggerMapping[loggerSubsystem] {
            return mappedSinks
        }

        var parentSubsystem = loggerSubsystem.retrieveParentSubsystemPath()
        while parentSubsystem != nil {
            if let parentSubsystem = parentSubsystem,
                let parentMappedSinks = loggerMapping[parentSubsystem] {
                return parentMappedSinks
            }

            parentSubsystem = loggerSubsystem.retrieveParentSubsystemPath()
        }

        return loggerMapping[""]
    }

    public func getMapping(loggerSubsystem: String,
                           category: String?,
                           logLevel: LogLevel) -> Set<String>? {
        var retVal: Set<String>

        retVal = Set(sinksIdentifiers)

        guard let mappedSinks = getClosestMapping(loggerSubsystem: loggerSubsystem) else {
            return retVal
        }

        for currentMappedSink in mappedSinks {
            if currentMappedSink.value.accept(loggerSubsystem: loggerSubsystem,
                                              category: category,
                                              logLevel: logLevel) == false {
                retVal.remove(currentMappedSink.key)
            }
        }

        return retVal
    }

    public func hasSinks(loggerSubsystem: String, category: String, logLevel: LogLevel) -> Bool {
        return getMapping(loggerSubsystem: loggerSubsystem, category: category, logLevel: logLevel) != nil
    }
}
