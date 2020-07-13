//
//  SinkFilterProtocol.swift
//  xray
//
//  Created by Anton Kononenko on 7/13/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public protocol SinkFilterProtocol {
    func accept(loggerSubsystem: String,
                category: String?,
                logLevel: LogLevel) -> Bool
}
