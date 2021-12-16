//
//  LoggerHelper+Actions.swift
//  LoggerInfo
//
//  Created by Alex Zchut on 16/12/2021.
//  Copyright © 2021 Applicaster Ltd. All rights reserved.
//

import AccordionSwift
import Foundation

extension LoggerHelper {
    public static func copyAction(forItem item: EventItem,
                                  completion: ((Result<Bool, Error>) -> Void)?) {
        UIPasteboard.general.string = item.name
        completion?(.success(true))
    }
}
