//
//  Email.swift
//  xray
//
//  Created by Anton Kononenko on 7/23/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import MessageUI
import MobileCoreServices

class Email: NSObject, MFMailComposeViewControllerDelegate {
    public var emailSubject = "Application Logs"
    public var defaultEmailBody = ""
    public var emailContextData: [String: AnyObject] = [:]

    func requestSendEmail(emails: [String],
                          sharedFileURL: URL?,
                          presenter: UIViewController?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()

            mail.setSubject(emailSubject)
            mail.setToRecipients(emails)
            mail.setMessageBody("Test", isHTML: false)

            if let sharedFileURL = sharedFileURL,
                let data = dataFromURL(url: sharedFileURL) {
                mail.addAttachmentData(data,
                                       mimeType: mimeTypeFromURL(url: sharedFileURL),
                                       fileName: sharedFileURL.lastPathComponent)
            }

            mail.mailComposeDelegate = self
            presentMailCompose(mail: mail)
        }
    }

    func presentMailCompose(mail: MFMailComposeViewController) {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

            if let topController = keyWindow?.rootViewController {
                topController.present(mail, animated: true, completion: nil)
            }
        } else {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(mail, animated: true, completion: nil)
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }

//    https://stackoverflow.com/questions/31243371/path-extension-and-mime-type-of-file-in-swift
    func mimeTypeFromURL(url: URL) -> String {
        let pathExtension = url.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }

    func dataFromURL(url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)

            return data
        } catch {
            print("Unable to load data: \(error)")
            return nil
        }
    }
}
