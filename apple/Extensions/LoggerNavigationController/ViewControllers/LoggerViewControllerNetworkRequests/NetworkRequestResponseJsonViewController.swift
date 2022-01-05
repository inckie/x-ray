//
//  NetworkRequestResponseJsonViewController.swift
//  LoggerInfo
//
//  Created by Anton Kononenko on 04/01/22.
//  Copyright © 2022 Applicaster. All rights reserved.
//

import Reporter
import UIKit
import XrayLogger

class NetworkRequestResponseJsonViewController: DetailedLoggerBaseViewController {
    var parentTitle: String?
    var dataObject: Any?

    struct Keys {
        static let request = "request"
        static let response = "response"
        static let body = "body"
    }

    @IBOutlet var requestTextView: UITextView!
    @IBOutlet var responseTextView: UITextView!

    override func prepareUI() {
        super.prepareUI()

        var options: JSONSerialization.WritingOptions = .prettyPrinted
        if #available(iOS 13.0, *) {
            options = [.prettyPrinted, .withoutEscapingSlashes]
        }

        if let response = event?.data?[Keys.response] as? [String: Any],
           let body = response[Keys.body] as? [String: Any] {
            var text: String?

            if let value = body.first?.value as? String {
                text = value
            } else if let jsonString = JSONHelper.convertObjectToJSONString(object: body.first?.value ?? [],
                                                                            options: options) {
                text = jsonString
            }
            responseTextView.text = text
        }

        if let request = event?.data?[Keys.request] as? [String: Any],
           let jsonString = JSONHelper.convertObjectToJSONString(object: request,
                                                                 options: options) {
            requestTextView.text = jsonString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = parentTitle ?? ""
        prepareUI()
    }

    @IBAction func showEventDetails(_ sender: UIBarButtonItem) {
        let bundle = Bundle(for: type(of: self))
        let detailedViewController = DetailedLoggerViewController(nibName: "DetailedLoggerViewController",
                                                                  bundle: bundle)
        detailedViewController.event = event
        detailedViewController.loggerType = loggerType
        detailedViewController.dateString = dateString
        navigationController?.pushViewController(detailedViewController,
                                                 animated: true)
    }
    
    @IBAction func requestCopyAction(_ sender: UIButton) {
        UIPasteboard.general.string = requestTextView.text
    }
    
    @IBAction func responseCopyAction(_ sender: UIButton) {
        UIPasteboard.general.string = responseTextView.text
    }
}
