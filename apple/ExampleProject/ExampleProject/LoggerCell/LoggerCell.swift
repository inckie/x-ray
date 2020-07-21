//
//  LoggerCell.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray

class LoggerCell: UICollectionViewCell {
    @IBOutlet weak var loggerTypeView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subsystemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        messageLabel.text = ""
        subsystemLabel.text = ""
        dateLabel.text = ""
        loggerTypeView.backgroundColor = UIColor.clear
    }

    func updateCell(event: Event,
                    dateString: String,
                    width: CGFloat) {
        roundCorners(radius: 10)
        messageLabel.text = event.message
        subsystemLabel.text = event.subsystem
        dateLabel.text = dateString
        loggerTypeView.backgroundColor = event.level.toColor()
        logTypeLabel.text = event.level.toString()
        logTypeLabel.textColor = event.level.toColor()
        cellWidthConstraint.constant = width
    }
}

