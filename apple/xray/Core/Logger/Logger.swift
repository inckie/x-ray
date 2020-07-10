//
//  Logger.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class Logger: NSObject {
    static let rootLogger = Logger(identifier: Bundle.main.bundleIdentifier ?? "",
                                   parent: nil)
    static let nameSeparator = "/"
    
    var identifier: String
    var children: [String: Logger] = [:]
    weak var parent: Logger?

    let context:[String:Any] = [:]
    //TODO: Make message formatter if needed here
    
    init(identifier: String, parent: Logger?) {
        self.identifier = identifier
        super.init()
    }
    
//    public func 
}
