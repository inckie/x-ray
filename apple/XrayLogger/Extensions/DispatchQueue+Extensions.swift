//
//  DispatchQueue+Extensions.swift
//  XrayLogger
//
//  Created by Alex Zchut on 01/08/2022.
//

import Foundation

public extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}
