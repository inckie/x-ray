//
//  DetailedLoggerViewController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray
class DetailedLoggerViewController: UIViewController {
    @IBOutlet weak var backgroundDataView: UIView!
    @IBOutlet weak var loggerTypeView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    let defaultEventFormatter = DefaultEventFormatter()
    var dateString:String?
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
        if let event = event {
            logTypeLabel.text = event.level.toString()
            logTypeLabel.textColor = event.level.toColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()

        loggerTypeView.backgroundColor = event?.level.toColor()
        backgroundDataView.backgroundColor = UIColor.white
//        backgroundDataView.roundCorners(corners: .allCorners, radius: 100)

        backgroundDataView.roundCorners(radius: 10)
        let message = defaultEventFormatter.format(event: event!)
        label.text = message
//       backgroundDataView.clipsToBounds = true
//        backgroundDataView.layer.cornerRadius = 15
//        backgroundDataView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
