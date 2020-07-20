//
//  Observer.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class Delegate: BaseSink {
    var observers: [NSObject] = []

    override public var asynchronously: Bool {
        get {
            return false
        }
        set {
        }
    }

    public func addObserver(item: Any) {
    }

    public func removeObserver(item: Any) {
    }

    override public func log(event: Event) {
        for item in observers {
            
        }
    }
}
