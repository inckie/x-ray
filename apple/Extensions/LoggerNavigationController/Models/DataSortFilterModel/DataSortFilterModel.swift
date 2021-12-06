//
//  DataSortFilterModel.swift
//  LoggerInfo
//
//  Created by Anton Kononenko on 12/30/20.
//

import Foundation

enum DataSortFilterModelKeys: String {
    case type
    case filterText
    case isEnabled
}

struct DataSortFilterModel: Equatable {
    let type: LoggerFiltersViewController.FilterType
    var filterText: String?

    init(type: LoggerFiltersViewController.FilterType,
         filterText: String? = nil,
         isEnabled: Bool) {
        self.type = type
        self.filterText = filterText
    }

    init?(data: [String: Any]) {
        guard let rawType = data[DataSortFilterModelKeys.type.rawValue] as? String,
              let type = LoggerFiltersViewController.FilterType(rawValue: rawType) else {
            return nil
        }

        self.type = type
        filterText = data[DataSortFilterModelKeys.filterText.rawValue] as? String
    }

    func toDict() -> [String: Any] {
        var retVal: [String: Any] = [
            DataSortFilterModelKeys.type.rawValue: type.rawValue,
        ]

        if let filterText = filterText {
            retVal[DataSortFilterModelKeys.filterText.rawValue] = filterText
        }

        return retVal
    }
}
