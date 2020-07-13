//
//  XrayLogger.swift
//  xray
//
//  Created by Anton Kononenko on 7/9/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public enum LogLevel: NSInteger {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
}

public class XrayLogger: NSObject {
    public static let sharedInstance = XrayLogger()
    private let mapper = Mapper()

    public private(set) var sinks: [String: SinkProtocol] = [:] {
        didSet {
            mapper.refreshSinks(sinks: sinks)
        }
    }

    // MARK: Sink Handlers

    /// returns boolean about success
    @discardableResult
    open func addSink(identifier: String,
                      sink: SinkProtocol) -> Bool {
        guard sinks[identifier] == nil else {
            return false
        }
        sinks[identifier] = sink
        return true
    }

    /// returns boolean about success
    @discardableResult
    open func getSink(_ indentifier: String) -> SinkProtocol? {
        guard let sink = sinks[indentifier] else {
            return nil
        }
        return sink
    }

    /// returns boolean about success
    @discardableResult
    open func removeSink(by indentifier: String) -> Bool {
        guard sinks[indentifier] != nil else {
            return false
        }
        sinks[indentifier] = nil
        return true
    }

    /// returns boolean about success
    @discardableResult
    open func removeSink(by sink: SinkProtocol) -> Bool {
        let itemToDelete = sinks.first { (item) -> Bool in
            // CHeck if it is working
            item.value === sink
        }
        guard let keyToDelete = itemToDelete?.key else {
            return false
        }

        sinks[keyToDelete] = nil
        return true
    }

    /// if you need to start fresh
    open func reset() {
        sinks.removeAll()
    }
}

extension XrayLogger {
    func submit(event: Event) {
    
    }

    func hasSinks(loggerSubsystem: String,
                  category: String,
                  logLevel: LogLevel) -> Bool {
        return mapper.hasSinks(loggerSubsystem: loggerSubsystem,
                               category: category,
                               logLevel: logLevel)
    }

    public func setFilter(loggerSubsystem: String,
                          sinkIdentifier: String,
                          filter: SinkFilterProtocol?) {
        mapper.setFilter(loggerSubsystem: loggerSubsystem,
                         sinkIdentifier: sinkIdentifier,
                         filter: filter)
    }
}
