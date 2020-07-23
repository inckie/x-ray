//
//  DetailedLoggerViewController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import MessageUI
import UIKit
import xray

class DetailedLoggerViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var backgroundDataView: UIView!
    @IBOutlet weak var loggerTypeView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jsonTextView: UITextView!

    @IBAction func exportData(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setSubject("Logger Data")
            mail.setToRecipients(["r.meirman@applicaster.com", "a.kononenko@applicaster.com", "a.smirnov@applicaster.com"])
            mail.setMessageBody("Test", isHTML: false)

            if let data = event?.toJSONString()?.data(using: .utf8),
                let levelString = event?.level.toString(),
                let dateString = dateString {
                mail.addAttachmentData(data,
                                       mimeType: "application/json",
                                       fileName: "\(levelString)_\(dateString).json")
            }

            if let event = event,
                let data = defaultEventFormatter.format(event: event).data(using: .utf8),
                let dateString = dateString {
                let levelString = event.level.toString()

                mail.addAttachmentData(data,
                                       mimeType: "text",
                                       fileName: "\(levelString)_\(dateString).log")
            }

            mail.mailComposeDelegate = self
            navigationController?.present(mail,
                                          animated: true,
                                          completion: nil)
        }
    }

    let defaultEventFormatter = DefaultEventFormatter()
    var dateString: String?
    var event: Event?

    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil,
                   bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func prepareUI() {
        dateLabel.text = dateString
        loggerTypeView.backgroundColor = event?.level.toColor()
        backgroundDataView.backgroundColor = UIColor.white
        backgroundDataView.roundCorners(radius: 10)
        if let event = event {
            logTypeLabel.text = event.level.toString()
            logTypeLabel.textColor = event.level.toColor()
            if let prettyPrintedJson = event.toJSONString(options: .prettyPrinted) {
                jsonTextView.text = prettyPrintedJson
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}
