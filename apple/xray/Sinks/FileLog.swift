//
//  Console.swift
//  xray
//
//  Created by Anton Kononenko on 7/17/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class FileLog: BaseSink, Storable {
    public private(set) var fileURL: URL?
    public var syncAfterEachWrite: Bool = false
    let fileManager = FileManager.default

    public init(fileName: String? = nil) {
        let fileName = fileName ?? "xray_file_log.txt"

        // sharedPublicDirectory
        if let url = fileManager.urls(for: .documentDirectory,
                                      in: .userDomainMask).first {
            fileURL = url.appendingPathComponent(fileName,
                                                 isDirectory: false)
        }

        super.init()
    }

    override public func log(event: Event) {
        guard let url = fileURL else { return }

        let message = formatter?.format(event: event) ?? event.message

        _ = FileManagerHelper.saveToFile(str: message,
                                         url: url,
                                         sync: syncAfterEachWrite)
    }

    public func deleteLogFile() -> Bool {
        guard let url = fileURL else { return true }

        let result = FileManagerHelper.deleteLogFile(url: url)
        return result
    }
}
