//
//  LoggerViewCollectionFlowLayout.swift
//  LoggerInfo
//
//  Created by Anton Kononenko on 9/9/20.
//

import Foundation
import XrayLogger

let sortLogsStorageKey = "xrayLoggerInfoLogsSorter"

protocol SortLogsViewDelegate: class {
    func userPushButon(logType: LogLevel,
                       selected: Bool)
}

struct SortLogsHelper {
    static func dataFromUserDefaults() -> [Int: Bool] {
        if let data = UserDefaults.standard.value(forKey: sortLogsStorageKey) as? Data,
            let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Int: Bool] {
            return result
        } else {
            let newData: [Int: Bool] = [
                LogLevel.verbose.rawValue: true,
                LogLevel.debug.rawValue: true,
                LogLevel.info.rawValue: true,
                LogLevel.warning.rawValue: true,
                LogLevel.error.rawValue: true,
            ]
            saveDataToUserDefaults(dataToSave: newData)
            return newData
        }
    }

    static func saveDataToUserDefaults(dataToSave: [Int: Bool]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: dataToSave)
        UserDefaults.standard.set(data,
                                  forKey: sortLogsStorageKey)
    }

    static func stateForLogLevel(logLevel: LogLevel,
                                 data: [Int: Bool]) -> Bool {
        guard let isSelected = data[logLevel.rawValue] else {
            return false
        }
        return isSelected
    }
}
