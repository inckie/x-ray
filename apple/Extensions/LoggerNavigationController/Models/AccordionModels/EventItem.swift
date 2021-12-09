//
//  EventItem.swift
//  QuickBrickXray
//
//  Created by Alex Zchut on 15/11/2021.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import Foundation

public struct EventParent: Hashable {
    let name: String
    let value: String
    
    public func prepareForExport() -> [String: String] {
        return [self.name: self.value]
    }
    
    public init(name: String,
                value: String = "") {
        self.name = name
        self.value = value
    }
}

public struct EventItem: Hashable {
    let name: String
    let parentName: String
    let value: String
    let valueJsonString: String?
    
    public func prepareForExport() -> [String: String] {
        return [self.name: self.value]
    }
    
    public init(name: String,
                parentName: String = "",
                value: String = "",
                valueJsonString: String? = nil) {
        self.name = name
        self.parentName = parentName
        self.value = ""
        self.valueJsonString = valueJsonString
    }
}
