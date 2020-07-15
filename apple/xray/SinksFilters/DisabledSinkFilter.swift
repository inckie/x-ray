//
//  DisabledSinkFilter.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class DisabledSinkFilter: NSObject, SinkFilterProtocol {
    public func accept(loggerSubsystem: String,
                category: String,
                logLevel: LogLevel) -> Bool {
        return false
    }
}
