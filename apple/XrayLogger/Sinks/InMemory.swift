//
//  Observer.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public protocol InMemoryObserverProtocol: NSObjectProtocol {
    func eventRecieved(event: Event,
                       eventsList: [Event])
}

public class InMemory: BaseSink {
    public var events: [Event] = []
    var observers: [String: InMemoryObserverProtocol] = [:]

    override public var asynchronously: Bool {
        get {
            return false
        }
        set {
        }
    }

    public func addObserver(identifier: String,
                            item: InMemoryObserverProtocol) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.observers[identifier] = item
        }
    }

    public func removeObserver(identifier: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.observers[identifier] = nil
        }
    }

    override public func log(event: Event) {
        events.append(event)
        updateObservers(event: event)
    }

    func updateObservers(event: Event) {
        for observer in observers {
            observer.value.eventRecieved(event: event,
                                         eventsList: events)
        }
    }

    public func toJSONString(options opt: JSONSerialization.WritingOptions = []) -> String? {
        let mappedEvents = events.map({ $0.toDictionary() })
        return JSONHelper.convertObjectToJSONString(object: mappedEvents,
                                                    options: opt)
    }
}
