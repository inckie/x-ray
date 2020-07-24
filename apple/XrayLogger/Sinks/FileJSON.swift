//
//  FileJSON.swift
//  xray
//
//  Created by Anton Kononenko on 7/17/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class FileJSON: BaseSink, Storable {
    public private(set) var fileURL: URL?

    public var syncAfterEachWrite: Bool = false
    let fileManager = FileManager.default

    public init(fileName: String? = nil) {
        let fileName = fileName ?? "xray_file.json"

        if let url = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask).first {
            fileURL = url.appendingPathComponent(fileName,
                                                 isDirectory: false)
        }

        super.init()
    }

    func getEvents() -> [[String: Any]] {
        do {
            guard let url = fileURL else { return [] }
            let data = try Data(contentsOf: url,
                                options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data,
                                                              options: []) as? [[String: Any]]
            return jsonResult ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    override public func log(event: Event) {
        guard let url = fileURL else { return }

        let dict = event.toDictionary()
        var jsonEvents = getEvents()
        jsonEvents.append(dict)
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonEvents,
                                                  options: [])
            try data.write(to: url,
                           options: [])
        } catch {
            print(error)
        }
    }

    public func deleteLogFile() -> Bool {
        guard let url = fileURL else { return true }

        let result = FileManagerHelper.deleteLogFile(url: url)
        return result
    }
}
