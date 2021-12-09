//
//  LoggerFiltersViewController.swift
//  LoggerInfo
//
//  Created by Alex Zchut on 01/12/2021.
//  Copyright © 2021 Applicaster Ltd. All rights reserved.
//

import Foundation

public class LoggerFiltersViewController: UIViewController {
    @IBOutlet var txtAny: UITextField!
    @IBOutlet var txtSubsystem: UITextField!

    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var txtMessage: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?

    public enum FilterType: String {
        case subsystem
        case category
        case message
        case any
    }

    var applyFilters: (([FilterType: String]) -> Void)?
    var keyboardHeightChanged: ((CGFloat) -> Void)?

    public static var filters: [FilterType: String] {
        set(newValue) {
            var filters: [String: String] = [:]
            for (key, value) in newValue {
                filters[key.rawValue] = value
            }
            UserDefaults.standard.set(filters,
                                      forKey: Params.storageKey)
        }
        get {
            guard let savedDict = UserDefaults.standard.value(forKey: Params.storageKey) as? [String: String] else {
                return [:]
            }

            var filters: [FilterType: String] = [:]
            for (key, value) in savedDict {
                if let filterType = FilterType(rawValue: key) {
                    filters[filterType] = value
                }
            }
            return filters
        }
    }

    var filters: [FilterType: String] {
        set(newValue) {
            Self.filters = newValue
        }
        get {
            return Self.filters
        }
    }

    struct Params {
        static let keyboardHiddenHeight = 0.0
        static let storageKey = "LoggerFiltersViewControllerFilters"
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }

        subscribeToKeyboardVisibilityChanges()
        updateTextfieldsContent()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtAny.delegate = self
        txtMessage.delegate = self
        txtCategory.delegate = self
        txtSubsystem.delegate = self
    }

    func updateTextfieldsContent() {
        for (key, value) in filters {
            switch key {
            case .any:
                txtAny.text = value
            case .message:
                txtMessage.text = value
            case .subsystem:
                txtSubsystem.text = value
            case .category:
                txtCategory.text = value
            }
        }
    }

    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func applyFilters(_ sender: UIButton) {
        if let text = txtAny.text, !text.isEmpty {
            filters[FilterType.any] = text
        }
        if let text = txtMessage.text, !text.isEmpty {
            filters[FilterType.message] = text
        }
        if let text = txtCategory.text, !text.isEmpty {
            filters[FilterType.category] = text
        }
        if let text = txtSubsystem.text, !text.isEmpty {
            filters[FilterType.subsystem] = text
        }
        applyFilters?(filters)
        dismiss(animated: true, completion: nil)
    }
}

extension LoggerFiltersViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
