//
//  String+Extensions.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        return String(dropFirst(prefix.count))
    }

    func retrieveParentSubsystemPath() -> String? {
        guard let lastSeparatorIndex = self.lastIndex(of: "/") else {
            return nil
        }

        let parentSubsystem = String(self[..<lastSeparatorIndex])
        return parentSubsystem
    }
}
