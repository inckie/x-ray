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

    func toString() -> String {
        switch self {
        case .verbose:
            return "verbose"
        case .debug:
            return "debug"
        case .info:
            return "info"
        case .warning:
            return "warning"
        case .error:
            return "error"
        }
    }
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
        DispatchQueue.global(qos: .default).sync {
            guard sinks[identifier] == nil else {
                return false
            }
            sinks[identifier] = sink
            return true
        }
    }

    /// returns boolean about success
    @discardableResult
    open func getSink(_ indentifier: String) -> SinkProtocol? {
        DispatchQueue.global(qos: .default).sync {
            guard let sink = sinks[indentifier] else {
                return nil
            }
            return sink
        }
    }

    /// returns boolean about success
    @discardableResult
    open func removeSink(by indentifier: String) -> Bool {
        DispatchQueue.global(qos: .default).sync {
            guard sinks[indentifier] != nil else {
                return false
            }
            sinks[indentifier] = nil
            return true
        }
    }

    /// returns boolean about success
    @discardableResult
    open func removeSink(by sink: SinkProtocol) -> Bool {
        DispatchQueue.global(qos: .default).sync {
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
    }

    /// if you need to start fresh
    open func reset() {
        DispatchQueue.global(qos: .default).sync {
            sinks.removeAll()
        }
    }
}

extension XrayLogger {
    func submit(event: Event) {
        let mapping = getMapping(event: event)
        if mapping.isEmpty == false {
            for sink in mapping {
                if sink.asynchronously {
                    sink.queue.async {
                        sink.log(event: event)
                    }

                } else {
                    sink.queue.sync {
                        sink.log(event: event)
                    }
                }
            }
        }
    }

    func getMapping(event: Event) -> [SinkProtocol] {
        DispatchQueue.global(qos: .default).sync {
            var retVal: [SinkProtocol] = []
            guard let enabledSinks = mapper.getMapping(loggerSubsystem: event.subsystem,
                                                       category: event.category,
                                                       logLevel: event.level) else {
                return retVal
            }
            for namedSink in sinks {
                if enabledSinks.contains(namedSink.key) {
                    retVal.append(namedSink.value)
                }
            }
            return retVal
        }
    }

    func hasSinks(loggerSubsystem: String,
                  category: String,
                  logLevel: LogLevel) -> Bool {
        DispatchQueue.global(qos: .default).sync {
            mapper.hasSinks(loggerSubsystem: loggerSubsystem,
                            category: category,
                            logLevel: logLevel)
        }
    }

    public func setFilter(loggerSubsystem: String,
                          sinkIdentifier: String,
                          filter: SinkFilterProtocol?) {
        DispatchQueue.global(qos: .default).sync {
            mapper.setFilter(loggerSubsystem: loggerSubsystem,
                             sinkIdentifier: sinkIdentifier,
                             filter: filter)
        }
    }
}
