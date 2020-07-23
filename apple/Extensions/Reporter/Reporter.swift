//
//  Reporter.swift
//  xray
//
//  Created by Anton Kononenko on 7/23/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import MessageUI

class Reporter {
    public private(set) var emails: [String]
    public private(set) var sharedFileURL: URL?

    let email = Email()

    init(email: String,
         url: URL?) {
        emails = [email]
        sharedFileURL = url
    }

    init(emails: [String],
         url: URL? = nil) {
        self.emails = emails
        sharedFileURL = url
    }

    public func requestSendEmail(emails: [String],
                                 sharedFileURL: URL?,
                                 presenter: UIViewController?) {
        email.requestSendEmail(emails: emails,
                               sharedFileURL: sharedFileURL,
                               presenter: presenter)
    }
    
    
}
