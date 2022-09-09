//
//  Date+Extensions.swift
//  xray
//
//  Created by Anton Kononenko on 9/9/20.
//  Copyright © 2022 Applicaster. All rights reserved.
//

import Foundation

extension Date {
    public var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
