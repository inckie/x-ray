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
                if let url = fileManager.urls(for: .cachesDirectory,
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
        let message = formatter?.format(event: event) ?? event.message
        _ = saveToFile(str: message)
    }

    /// returns boolean about success
    @discardableResult func saveToFile(str: String) -> Bool {
        guard let url = fileURL else { return false }

        let line = str + "\n"
        guard let data = line.data(using: String.Encoding.utf8) else { return false }

        do {
            if fileManager.fileExists(atPath: url.path) == false {
                let directoryURL = url.deletingLastPathComponent()
                if fileManager.fileExists(atPath: directoryURL.path) == false {
                    try fileManager.createDirectory(
                        at: directoryURL,
                        withIntermediateDirectories: true
                    )
                }
                fileManager.createFile(atPath: url.path, contents: nil)

                #if os(iOS) || os(watchOS)
                    var attributes = try fileManager.attributesOfItem(atPath: url.path)
                    attributes[FileAttributeKey.protectionKey] = FileProtectionType.none
                    try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
                #endif
            }
            write(data: data, to: url)

            return true
        } catch {
            print("Sink File can not save file: \(url).")
            return false
        }
    }

    private func write(data: Data, to url: URL) {
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var error: NSError?
        coordinator.coordinate(writingItemAt: url, error: &error) { url in
            do {
                let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                if syncAfterEachWrite {
                    fileHandle.synchronizeFile()
                }
                fileHandle.closeFile()
            } catch {
                print("Sink File could not write to file \(url).")
                return
            }
        }

        if let error = error {
            print("Failed writing file with error: \(String(describing: error))")
        }
    }

    /// deletes log file.
    /// returns true if file was removed or does not exist, false otherwise
    public func deleteLogFile() -> Bool {
        guard let url = fileURL,
            fileManager.fileExists(atPath: url.path) == true else { return true }
        do {
            try fileManager.removeItem(at: url)
            return true
        } catch {
            print("Sink File could not remove file \(url).")
            return false
        }
    }
}
