//
//  EventBuilder.swift
//  xray
//
//  Created by Anton Kononenko on 7/10/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class EventBuilder: NSObject {
    class func submit(subsystem: String,
                      logLevel: LogLevel = .debug,
                      category: String,
                      data: [String: Any]? = nil,
                      context: [String: Any]? = nil,
                      messageFormatter: MessageFormatterProtocol? = nil,
                      message: String,
                      exception: NSException?,
                      otherArgs: Any...) {
        let event = Event(category: category,
                          subsystem: subsystem,
                          timestamp: UInt(round(NSDate().timeIntervalSince1970)),
                          message: message,
                          data: data,
                          context: context,
                          exception: exception)
        XrayLogger.sharedInstance.submit(event: event)
    }

    private func formatMessage(messageFormatter: MessageFormatterProtocol?,
                               message: String,
                               data: [String: Any],
                               otherArgs: Any...) -> String {
        guard let messageFormatter = messageFormatter else {
            return message
        }
        return messageFormatter.format(template: message,
                                       prameters: data,
                                       otherArgs: otherArgs)
    }
}
