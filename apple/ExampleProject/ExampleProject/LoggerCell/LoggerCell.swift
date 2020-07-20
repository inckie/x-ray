//
//  LoggerCell.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray

class LoggerCell: UITableViewCell {
    @IBOutlet var loggerTypeView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var subsystemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func prepareForReuse() {
        messageLabel.text = ""
        subsystemLabel.text = ""
        dateLabel.text = ""
        loggerTypeView.backgroundColor = UIColor.clear
    }

    func updateCell(event: Event) {
        roundCorners(.allCorners,
                     radius: 10)
        messageLabel.text = event.message
        subsystemLabel.text = event.subsystem
        loggerTypeView.backgroundColor = event.level.toColor()
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
