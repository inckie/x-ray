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
    @IBOutlet var loggerTypeView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var subsystemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var logTypeLabel: UILabel!

    override func prepareForReuse() {
        messageLabel.text = ""
        subsystemLabel.text = ""
        dateLabel.text = ""
        loggerTypeView.backgroundColor = UIColor.clear
    }

    func updateCell(event: Event,
                    dateString: String) {
        roundCorners(.allCorners,
                     radius: 10)
        setCardView()
        messageLabel.text = event.message
        subsystemLabel.text = event.subsystem
        dateLabel.text = dateString
        loggerTypeView.backgroundColor = event.level.toColor()
        arrowImageView.tintColor = event.level.toColor()
        logTypeLabel.text = event.level.toString()
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func setCardView() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 5.0
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.masksToBounds = true
    }
}
