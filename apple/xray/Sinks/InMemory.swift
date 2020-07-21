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
    var events: [Event] = []
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
        observers[identifier] = item
    }

    public func removeObserver(identifier: String) {
        observers[identifier] = nil
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
}
