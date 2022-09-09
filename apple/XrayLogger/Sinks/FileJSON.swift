//
//  FileJSON.swift
//  xray
//
//  Created by Anton Kononenko on 7/17/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class FileJSON: BaseSink {
    fileprivate var logsFolderURL: URL?
    fileprivate let singleLogsFileName = "XrayJsonLogs.json"
    public var maxLogFileSizeInMB: Double? = 20
    public var deleteLogsFolderContentForNewAppVersion = true
    public var syncAfterEachWrite: Bool = false
    let fileManager = FileManager.default
    let defaultsSuite: String = "Xray_FileJSON"
    let defaultsAppVersionKey: String = "current_application_version"
    var cleanLogfileEvent: Event {
        return Event(category: "",
                     subsystem: "Sink.FileJSON",
                     timestamp: Date().millisecondsSince1970,
                     level: .verbose,
                     message: "Events log cleaned",
                     data: nil,
                     context: nil,
                     exception: nil)
    }

    public init(folderName: String? = nil) {
        let folderName = folderName ?? "XrayJsonLogs"

        if let url = fileManager.documentFolder {
            let dataPath = url.appendingPathComponent(folderName)

            if fileManager.createDirectoryIfNeeded(at: dataPath) {
                logsFolderURL = dataPath
            }
        }

        super.init()
        updateApplicationVersionInUserDefaults()
    }

    override public func log(event: Event) {
        guard let logsFolderURL = logsFolderURL else {
            return
        }
        deleteLogFilesIfNeeded(at: logsFolderURL)

        let dict = event.toDictionary()
        guard JSONSerialization.isValidJSONObject(dict) else {
            return
        }
        let fileUrl = logsFolderURL.appendingPathComponent("\(UUID().uuidString).json")
        JSONHelper.writeObjectToFile(object: dict, at: fileUrl)
    }

    public func deleteLogsFolderContent(at path: URL) {
        guard let filePaths = try? fileManager.contentsOfDirectory(at: path,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: []) else {
            return
        }

        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }

    private func deleteLogFilesIfNeeded(at path: URL) {
        if isFolderSizeLimitRiched(at: path) {
            deleteLogsFolderContent(at: path)

            // save event of log file cleanup
            log(event: cleanLogfileEvent)
        }
    }

    private func isFolderSizeLimitRiched(at path: URL) -> Bool {
        guard let maxLogFileSizeInMB = maxLogFileSizeInMB,
              let fileSizeInMB = FileManagerHelper.fileSizeInMB(forURL: path),
              fileSizeInMB > maxLogFileSizeInMB else {
            return false
        }
        return true
    }

    private func applicationHasNewVersion() -> String? {
        guard
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else {
            return nil
        }

        let currentApplicationVersion = UserDefaults(suiteName: defaultsSuite)?.string(forKey: defaultsAppVersionKey)

        return currentApplicationVersion != appVersion ? appVersion : nil
    }

    private func updateApplicationVersionInUserDefaults() {
        guard let newApplicationVersion = applicationHasNewVersion()
        else {
            return
        }

        if deleteLogsFolderContentForNewAppVersion == true {
            guard let logsFolderURL = logsFolderURL else {
                return
            }
            deleteLogsFolderContent(at: logsFolderURL)
        }

        UserDefaults(suiteName: defaultsSuite)?.setValue(newApplicationVersion,
                                                         forKey: defaultsAppVersionKey)
    }
}

extension FileJSON: Storable {
    public func generateLogsToSingleFileUrl(_ completion: ((URL?) -> Void)?) {
        guard let logsFolderURL = logsFolderURL,
              let cacheFolder = fileManager.cacheFolder,
              let filePaths = try? fileManager.contentsOfDirectory(at: logsFolderURL,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: []),
              filePaths.count > 0 else {
            completion?(nil)
            return
        }

        let contextKey = "context"
        var events: [[String: Any]] = []
        for filePath in filePaths {
            let fileEvent = getEvent(fromFile: filePath)
            events.append(fileEvent)
        }

        if let firstEventWithContext = events.first(where: { event in
            guard let eventContext = event[contextKey] as? [String: Any],
                  eventContext.count > 0 else {
                return false
            }
            return true
        }) {
            // remove context from events
            events = events.compactMap({ event in
                var updatedEvent = event
                updatedEvent.removeValue(forKey: contextKey)
                return updatedEvent
            })
            // create new event with context
            let contextEvent = createContextEvent(with: firstEventWithContext)
            events.append(contextEvent)
        }

        let singleLogsFileUrl = cacheFolder.appendingPathComponent(singleLogsFileName,
                                                                   isDirectory: false)
        let success = JSONHelper.writeObjectToFile(object: events, at: singleLogsFileUrl)

        completion?(success ? singleLogsFileUrl : nil)
    }

    public func deleteSingleFileUrl() {
        guard let cacheFolder = fileManager.cacheFolder else {
            return
        }
        let singleLogsFileUrl = cacheFolder.appendingPathComponent(singleLogsFileName,
                                                                   isDirectory: false)
        _ = FileManagerHelper.deleteLogFile(url: singleLogsFileUrl)
    }

    fileprivate func getEvent(fromFile fileUrl: URL) -> [String: Any] {
        do {
            let data = try Data(contentsOf: fileUrl,
                                options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data,
                                                              options: []) as? [String: Any]
            return jsonResult ?? [:]
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    }
}
