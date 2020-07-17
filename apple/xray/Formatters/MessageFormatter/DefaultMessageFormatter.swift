//
//  DefaultMessageFormatter.swift
//  xray
//
//  Created by Anton Kononenko on 7/13/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class DefaultMessageFormatter: MessageFormatterProtocol {
    func format(template: String,
                prameters: [String: Any]?,
                args: [CVarArg]) -> String {
        guard args.count > 0 else {
            return template
        }
        let retVal = String(format: template,
                            arguments: args)

        return retVal
    }
    
}
