//
//  Console.swift
//  xray
//
//  Created by Anton Kononenko on 7/17/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class File: BaseSink {
    var fileURL: URL?
    public var syncAfterEachWrite: Bool = false
    let fileManager = FileManager.default

    public init(logFileURL: URL? = nil) {
        if let fileURL = fileURL {
            self.fileURL = fileURL
            super.init()
            return
        }

        // platform-dependent logfile directory default
        var baseURL: URL?
        #if os(OSX)
            if let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                baseURL = url
                if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String {
                    do {
                        if let appURL = baseURL?.appendingPathComponent(appName, isDirectory: true) {
                            try fileManager.createDirectory(at: appURL,
                                                            withIntermediateDirectories: true, attributes: nil)
                            baseURL = appURL
                        }
                    } catch {
                        print("Warning! Could not create folder /Library/Caches/\(appName)")
                    }
                }
            }
        #else
            #if os(Linux)
                baseURL = URL(fileURLWithPath: "/var/cache")
            #else
                // iOS, watchOS, etc. are using the caches directory
                if let url = fileManager.urls(for: .cachesDirectory, //sharedPublicDirectory
                                              in: .userDomainMask).first {
                    baseURL = url
                }
            #endif
        #endif

        if let baseURL = baseURL {
            fileURL = baseURL.appendingPathComponent("xray.log",
                                                     isDirectory: false)
        }

        super.init()
    }

    // append to file. uses full base class functionality
    override public func log(event: Event) {
        guard let url = fileURL else { return }

        let message = formatter?.format(event: event) ?? event.message

        _ = FileManagerHelper.saveToFile(str: message,
                                         url: url,
                                         sync: syncAfterEachWrite)
    }

    /// deletes log file.
    /// returns true if file was removed or does not exist, false otherwise
    public func deleteLogFile() -> Bool {
        guard let url = fileURL else { return true }

        let result = FileManagerHelper.deleteLogFile(url: url)
        return result
    }
}
