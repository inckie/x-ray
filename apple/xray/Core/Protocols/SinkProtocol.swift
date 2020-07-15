//
//  SinkProtocol.swift
//  xray
//
//  Created by Anton Kononenko on 7/9/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public protocol SinkProtocol: NSObjectProtocol {
    func log(event: Event)
    var formatter: EventFormatterProtocol? { get set }
    var asynchronously: Bool { get set }
    var queue: DispatchQueue { get set }
}
