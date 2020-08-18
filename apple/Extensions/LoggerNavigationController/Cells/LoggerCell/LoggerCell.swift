//
//  LoggerCell.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import XrayLogger

class LoggerCell: UICollectionViewCell {
    @IBOutlet weak var loggerTypeView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var subsystemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logTypeLabel: UILabel!

    override func prepareForReuse() {
        messageLabel.text = ""
        subsystemLabel.text = ""
        dateLabel.text = ""
        loggerTypeView.backgroundColor = UIColor.clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    // Note: must be strong
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }

    func updateCell(event: Event,
                    dateString: String,
                    maxWidth: CGFloat) {
        roundCorners(radius: 10)
        messageLabel.text = event.message + "sfsfsfs df dsf df sd fs df sd sdf gdfgsdfgdfgs dfgsfdgdfgdf g dfdfdfgdfg"
        subsystemLabel.text = event.subsystem + "sfsfsfs df dsf df sd fs df sd sdf gdfgsdfgdfgs dfgsfdgdfgdf g dfdfdfgdfg"
        dateLabel.text = dateString
        loggerTypeView.backgroundColor = event.level.toColor()
        logTypeLabel.text = event.level.toString()
        logTypeLabel.textColor = event.level.toColor()
        self.maxWidth = maxWidth
    }
}

