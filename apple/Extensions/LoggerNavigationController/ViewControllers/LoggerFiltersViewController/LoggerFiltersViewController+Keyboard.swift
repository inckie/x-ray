//
//  LoggerFiltersViewController+Keyboard.swift
//  LoggerInfo
//
//  Created by Alex Zchut on 01/12/2021.
//  Copyright © 2021 Applicaster Ltd. All rights reserved.
//

import Foundation

extension LoggerFiltersViewController {
    func subscribeToKeyboardVisibilityChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            keyboardHeightLayoutConstraint?.constant = height
            keyboardHeightChanged?(height)
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeightLayoutConstraint?.constant = Params.keyboardHiddenHeight
        keyboardHeightChanged?(Params.keyboardHiddenHeight)
        view.layoutIfNeeded()
    }
}
