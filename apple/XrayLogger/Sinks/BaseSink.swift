//
//  BaseSink.swift
//  xray
//
//  Created by Anton Kononenko on 7/14/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class BaseSink: NSObject, SinkProtocol {
    public var queue: DispatchQueue = {
        let uuid = NSUUID().uuidString
        let queueLabel = "sink-\(uuid)"
        return DispatchQueue(label: queueLabel)
    }()

    open var asynchronously = true

    public var formatter: EventFormatterProtocol? = DefaultEventFormatter()

    public func log(event: Event) {
        // Shoulds be implemented on top lovel
    }

    public static func == (lhs: BaseSink, rhs: BaseSink) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func createContextEvent(with event: Event?) -> [String: Any] {
        guard let event = event else {
            return [:]
        }
        return createContextEvent(with: event.toDictionary())
    }
    
    public func createContextEvent(with eventData: [String: Any]) -> [String: Any] {
        let event = Event(category: "",
                          subsystem: "",
                          timestamp: UInt(Date().timeIntervalSince1970),
                          message: "Initial event with context",
                          data: nil,
                          context: eventData["context"] as? [String: Any],
                          exception: nil)
        return event.toDictionary()
    }
}
