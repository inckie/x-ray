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
    fileprivate let singleLogsFileName = "XrayLogs.json"
    let fileManager = FileManager.default

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

extension InMemory: Storable {
    public func generateLogsToSingleFileUrl(_ completion: ((URL?) -> Void)?) {
        guard let documentsFolder = fileManager.cacheFolder else {
            completion?(nil)
            return
        }
        let singleLogsFileUrl = documentsFolder.appendingPathComponent(singleLogsFileName,
                                                                       isDirectory: false)
        var success = false
        var exportEvents = events.compactMap { $0.toDictionary(shouldIncludeContext: false) }
        let contextEvent = createContextEvent(with: events.first)
        exportEvents.append(contextEvent)
        success = JSONHelper.writeObjectToFile(object: exportEvents, at: singleLogsFileUrl)

        completion?(success ? singleLogsFileUrl : nil)
    }

    public func deleteSingleFileUrl() {
        guard let documentsFolder = fileManager.cacheFolder else {
            return
        }
        let singleLogsFileUrl = documentsFolder.appendingPathComponent(singleLogsFileName,
                                                                       isDirectory: false)
        _ = FileManagerHelper.deleteLogFile(url: singleLogsFileUrl)
    }
}
