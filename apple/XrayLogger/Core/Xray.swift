//
//  Xray.swift
//  xray
//
//  Created by Anton Kononenko on 7/9/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit

public enum LogLevel: NSInteger {
    case verbose
    case debug
    case info
    case warning
    case error

    public func toString() -> String {
        switch self {
        case .verbose:
            return "VERBOSE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }

    public func toColor() -> UIColor {
        switch self {
        case .verbose:
            return UIColor(red: 0 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
        case .debug:
            return UIColor(red: 0 / 255, green: 76 / 255, blue: 153 / 255, alpha: 1)
        case .info:
            return UIColor(red: 153 / 255, green: 153 / 255, blue: 0 / 255, alpha: 1)
        case .warning:
            return UIColor(red: 153 / 255, green: 76 / 255, blue: 0 / 255, alpha: 1)
        case .error:
            return UIColor(red: 153 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        }
    }
}

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


public class Xray: NSObject {
    public static let sharedInstance = Xray()
    private let queue = DispatchQueue(label: "XrayQueue")
    
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
        queue.sync {
            guard let sink = sinks[indentifier] else {
                return nil
            }
            return sink
        }
    }

    /// returns boolean about success
    @discardableResult
    open func removeSink(by indentifier: String) -> Bool {
        queue.sync {
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
        queue.sync {
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
        queue.sync {
            sinks.removeAll()
        }
    }
}

extension Xray {
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
        queue.sync {
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
        queue.sync {
            mapper.hasSinks(loggerSubsystem: loggerSubsystem,
                            category: category,
                            logLevel: logLevel)
        }
    }

    public func setFilter(loggerSubsystem: String,
                          sinkIdentifier: String,
                          filter: SinkFilterProtocol?) {
        queue.sync {
            mapper.setFilter(loggerSubsystem: loggerSubsystem,
                             sinkIdentifier: sinkIdentifier,
                             filter: filter)
        }
    }
}
