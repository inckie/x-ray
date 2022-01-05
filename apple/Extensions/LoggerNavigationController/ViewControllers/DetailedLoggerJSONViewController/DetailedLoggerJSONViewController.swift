//
//  DetailedLoggerJSONViewController.swift
//  LoggerInfo
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Reporter
import UIKit
import XrayLogger

class DetailedLoggerJSONViewController: DetailedLoggerBaseViewController {
    var parentTitle: String?
    var dataObject: Any?

    @IBOutlet var jsonTextView: UITextView!

    override func prepareUI() {
        super.prepareUI()
        if let dataObject = dataObject {
            jsonTextView.text = JSONHelper.convertObjectToJSONString(object: dataObject, options: .prettyPrinted)
            toolbar.removeFromSuperview()
        } else if let prettyPrintedJson = event?.toJSONString(options: .prettyPrinted) {
            jsonTextView.text = prettyPrintedJson
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = parentTitle ?? "Json output"
        prepareUI()
    }
}
