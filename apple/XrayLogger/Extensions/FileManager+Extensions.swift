//
//  FileManager+Extensions.swift
//  XrayLogger
//
//  Created by Alex Zchut on 20/12/2021.
//

import Foundation

extension FileManager {
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    func createDirectoryIfNeeded(at url: URL) -> Bool {
        var retValue = false
        if !directoryExists(at: url) {
            do {
                try createDirectory(atPath: url.path,
                                    withIntermediateDirectories: true,
                                    attributes: nil)
                retValue = true
            } catch {}
        } else {
            retValue = true
        }
        return retValue
    }

    var cacheFolder: URL? {
        return urls(for: .cachesDirectory,
                    in: .userDomainMask).first
    }
    
    var documentFolder: URL? {
        return urls(for: .documentDirectory,
                    in: .userDomainMask).first
    }
}
