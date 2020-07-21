//
//  MailComposerViewControllerBuilder.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import MessageUI

//// string.data(using: .utf8)
//class MailComposerViewControllerBuilder {
//    class func presentMailComposer(completion: (result: MFMailComposeResult, error: Error?)) {
//        guard MFMailComposeViewController.canSendMail() else {
//            completion(result:.cancelled, error:Error(message:"ff"))
//        }
//    }
//}
//
//func sendEmail() {
//    if MFMailComposeViewController.canSendMail() {
//        let mail = MFMailComposeViewController()
//        mail.mailComposeDelegate = self
//        mail.setToRecipients(["you@yoursite.com"])
//        mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
//
//        present(mail, animated: true)
//    } else {
//        // show failure alert
//    }
//}
//
//func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//    controller.dismiss(animated: true)
//}
