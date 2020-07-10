//
//  Event.swift
//  xray
//
//  Created by Anton Kononenko on 7/9/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import os.log
struct Event {
    //iOS-Category
    let category: String
    let subsystem: String // Substem
    let timestamp: Double = round(NSDate().timeIntervalSince1970) // UTC
    let level: Int
    let message: String
    let data: [String: Any]?  // What func, line
    let context: [String: Any]?
//    let exception: NSException? // todo: not sure about this one, maybe handle it in event builder and add to data?
}
