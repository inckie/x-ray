//
//  LoggerViewControllerBase.swift
//  Xray
//
//  Created by Alex Zchut on 02/25/21.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import MessageUI
import Reporter
import UIKit
import XrayLogger

public enum LoggerViewType {
    case undefined
    case logger
    case networkRequests
}

public class LoggerViewControllerBase: UIViewController {
    private let screenIdentifier = "LoggerScreen"
    var className: String = ""

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var resetFilterBarButtonItem: UIBarButtonItem!

    public weak var activeSink: BaseSink?

    // Original data source returned from sink
    var originalDataSource: [Event] = []

    // Filtered models by filter DataSortFilterModel
    var filteredDataSource: [Event] = []

    // Filtered models by filter DataSortFilterModel and log type buttons
    var filteredDataSourceByType: [Event] = []

    var filterModels: [DataSortFilterModel] {
        LoggerFiltersViewController.filters.map({ (key: FilterType, value: String) in
            DataSortFilterModel(type: key, filterText: value, isEnabled: true)
        })
    }

    var formatter: EventFormatterProtocol?
    var asynchronously: Bool {
        get {
            return false
        }
        set(newValue) {
        }
    }

    var sortParams: [Int: Bool] = [:]
    var loggerType: LoggerViewType = .undefined

    let dateFormatter = DateFormatter()
    public var format = "yyyy-MM-dd HH:mm:ssZ"

    deinit {
        activeSink = nil
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        className = "\(type(of: self))"

        xibSetup()
        initilizeSortData()
        collectionViewSetup()
        prepareLogger()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.view.bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        self.view = view
    }

    func prepareLogger() {
        // override in child classes
    }

    func getSortParams() -> [Int: Bool] {
        // override in child classes
        return [:]
    }

    func getCellIdentifier() -> String {
        // override in child classes
        return "undefined"
    }

    func initilizeSortData() {
        // override in child classes
        sortParams = getSortParams()
    }

    func collectionViewSetup() {
        let bundle = Bundle(for: type(of: self))

        collectionView?.register(UINib(nibName: getCellIdentifier(),
                                       bundle: bundle),
                                 forCellWithReuseIdentifier: getCellIdentifier())
    }

    // override in child classes
    func loadViewFromNib() -> UIView? {
        let nibName = className
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    func dateStringFromEvent(event: Event) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(event.timestamp))
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    @IBAction func exportData(_ sender: UIBarButtonItem) {
        Reporter.requestSendEmail()
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        let presenter = UIApplication.shared.keyWindow?.rootViewController
        presenter?.presentedViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func presentFilterViewController(_ sender: UIBarButtonItem) {
        let vc = LoggerFiltersViewController(nibName: "LoggerFiltersViewController",
                                             bundle: Bundle(for: type(of: self)))

        struct Params {
            static let initialPopupHeight = 430.0
        }

        vc.applyFilters = { [weak self] _ in
            self?.applyNewFilters()
        }

        vc.keyboardHeightChanged = { [weak self] keyboardHeight in
            // handle keyboard presentation change
            let updatedHeight = Params.initialPopupHeight + keyboardHeight
            guard let popupVC = self?.presentedViewController as? PopupViewController else {
                return
            }
            UIView.animate(withDuration: 1.2) {
                popupVC.heightConstraint?.constant = updatedHeight
            }
        }

        let popupVC = PopupViewController(contentController: vc,
                                          position: .bottom(0),
                                          popupWidth: view.frame.width,
                                          popupHeight: Params.initialPopupHeight)
        popupVC.cornerRadius = 15
        popupVC.backgroundAlpha = 0.0
        popupVC.backgroundColor = .clear
        popupVC.canTapOutsideToDismiss = true
        popupVC.shadowEnabled = true
        popupVC.modalPresentationStyle = .popover
        present(popupVC, animated: true, completion: nil)
    }

    @IBAction func resetFilter(_ sender: UIBarButtonItem) {
        LoggerFiltersViewController.filters = [:]
        applyNewFilters()
    }

    func applyNewFilters() {
        filterDataSource()
        collectionView.reloadData()
        if filteredDataSourceByType.count > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                        at: .top,
                                        animated: false)
        }
    }

    func filterDataSource() {
        resetFilterBarButtonItem.isEnabled = filterModels.count > 0
        filteredDataSource = DataSortFilterHelper.filterDataSource(filterData: filterModels,
                                                                   allEvents: originalDataSource)
        filteredDataSourceByType = filterDataSourceByType()
    }

    func filterDataSourceByType() -> [Event] {
        // override in child classes
        return []
    }
}

extension LoggerViewControllerBase: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = Bundle(for: type(of: self))
        let detailedViewController = DetailedLoggerViewController(nibName: "DetailedLoggerViewController",
                                                                  bundle: bundle)
        let event = filteredDataSourceByType[indexPath.row]
        detailedViewController.event = event
        detailedViewController.loggerType = loggerType
        detailedViewController.dateString = dateStringFromEvent(event: event)
        navigationController?.pushViewController(detailedViewController,
                                                 animated: true)
    }
}

extension LoggerViewControllerBase: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return filteredDataSourceByType.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(),
                                                      for: indexPath) as? LoggerCellProtocol
        let event = filteredDataSourceByType[indexPath.row]
        let formattedDate = dateStringFromEvent(event: event)
        cell?.updateCell(event: event,
                         dateString: formattedDate)

        return cell as! UICollectionViewCell
    }
}

extension LoggerViewControllerBase: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 120)
    }
}
