//
//  Reporter.swift
//  xray
//
//  Created by Anton Kononenko on 7/23/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import MessageUI

public class Reporter {
    public static let sharedInstance = Reporter()
    public private(set) static var sharedEmails: [String]?
    public private(set) static var sharedFileURL: URL?
    public private(set) static var sharedContexts: [String: Any]?
    var email = Email()

    public static func setDefaultData(emails: [String],
                                      url: URL?,
                                      contexts: [String: Any]?) {
        sharedEmails = emails
        sharedFileURL = url
        sharedContexts = contexts
    }

    public static func requestSendEmail(presenter: UIViewController? = nil) {
        guard let sharedEmails = sharedEmails else {
            print("Can not send email, at least one sender must be defined")
            return
        }
        sharedInstance.email.requestSendEmail(emails: sharedEmails,
                                              sharedFileURL: sharedFileURL,
                                              contexts: sharedContexts,
                                              attachments: nil,
                                              presenter: presenter)
    }

    public static func requestSendCustomEmail(attachments: [EmailAttachment]? = nil,
                                              presenter: UIViewController? = nil) {
        guard let emails = sharedEmails else {
            print("Can not send email, at least one sender must be defined")
            return
        }

        sharedInstance.email.requestSendEmail(emails: emails,
                                              sharedFileURL: nil,
                                              contexts: sharedContexts,
                                              attachments: attachments,
                                              presenter: presenter)
    }
}
