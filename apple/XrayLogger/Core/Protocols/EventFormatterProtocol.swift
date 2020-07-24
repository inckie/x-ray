//
//  EventFormatterProtocol.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public protocol EventFormatterProtocol {
    func format(event: Event) -> String
}
