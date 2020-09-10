//
//  LoggerViewController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import MessageUI
import Reporter
import UIKit
import XrayLogger

class LoggerViewController: UIViewController {
    private let cellIdentifier = "LoggerCell"
    private let screenIdentifier = "LoggerScreen"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortLogsView: SortLogsView!

    private(set) weak var inMemorySink: InMemory?

    var originalDataSource: [Event] = []
    var filteredDataSource: [Event] = []

    var formatter: EventFormatterProtocol?
    var sortParams = SortLogsHelper.dataFromUserDefaults()
    var asynchronously: Bool {
        get {
            return false
        }
        set(newValue) {
        }
    }

    let dateFormatter = DateFormatter()
    public var format = "yyyy-MM-dd HH:mm:ssZ"

    deinit {
        inMemorySink = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        initilizeSortData()
        collectionViewSetup()
        prepareLogger()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.view.bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        self.view = view
    }

    func prepareLogger() {
        title = "Logger Screen"

        let inMemorySink = XrayLogger.sharedInstance.getSink("InMemorySink") as? InMemory
        self.inMemorySink = inMemorySink
        if let events = inMemorySink?.events {
            originalDataSource = events
            filteredDataSource = filterDataSource()
            // invalidate layout during presentation anumation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }

    func collectionViewSetup() {
        let collectionViewFlowLayout = LoggerViewCollectionFlowLayout()
        collectionView?.collectionViewLayout = collectionViewFlowLayout
        collectionView?.contentInsetAdjustmentBehavior = .always

        let bundle = Bundle(for: type(of: self))
        collectionView?.register(UINib(nibName: cellIdentifier,
                                       bundle: bundle),
                                 forCellWithReuseIdentifier: cellIdentifier)
    }

    func loadViewFromNib() -> UIView? {
        let nibName = "LoggerViewController"
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
}

extension LoggerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = Bundle(for: type(of: self))
        let detailedViewController = DetailedLoggerViewController(nibName: "DetailedLoggerViewController",
                                                                  bundle: bundle)
        let event = filteredDataSource[indexPath.row]
        detailedViewController.event = event
        detailedViewController.dateString = dateStringFromEvent(event: event)
        navigationController?.pushViewController(detailedViewController,
                                                 animated: true)
    }
}

extension LoggerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! LoggerCell
        let event = filteredDataSource[indexPath.row]
        let formattedDate = dateStringFromEvent(event: event)
        cell.updateCell(event: event,
                        dateString: formattedDate)

        return cell
    }
}

extension LoggerViewController: SortLogsViewDelegate {
    func userPushButon(logType: LogLevel, selected: Bool) {
        sortParams[logType.rawValue] = selected
        SortLogsHelper.saveDataToUserDefaults(dataToSave: sortParams)
        filteredDataSource = filterDataSource()
        collectionView.reloadData()

        collectionView.performBatchUpdates(nil) { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func initilizeSortData() {
        sortLogsView.delegate = self
        sortLogsView.initializeButtons(defaultStates: sortParams)
    }

    func filterDataSource() -> [Event] {
        return originalDataSource.filter { (event) -> Bool in
            if let selected = sortParams[event.level.rawValue] {
                return selected
            }
            return false
        }
    }
}
