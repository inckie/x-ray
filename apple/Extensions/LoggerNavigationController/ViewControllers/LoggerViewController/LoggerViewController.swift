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
    private(set) weak var inMemorySink: InMemory?

    // IdentifierSink -> Obesrver
    var dataSource: [Event] = []

    var formatter: EventFormatterProtocol?

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
        inMemorySink?.removeObserver(identifier: screenIdentifier)
        inMemorySink = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewSetup()
        prepareLogger()
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
        inMemorySink?.addObserver(identifier: screenIdentifier,
                                  item: self)
        self.inMemorySink = inMemorySink
        if let events = inMemorySink?.events {
            dataSource = events

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
        let event = dataSource[indexPath.row]
        detailedViewController.event = event
        detailedViewController.dateString = dateStringFromEvent(event: event)
        navigationController?.pushViewController(detailedViewController,
                                                 animated: true)
    }
}

extension LoggerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! LoggerCell
        let event = dataSource[indexPath.row]
        let formattedDate = dateStringFromEvent(event: event)
        cell.updateCell(event: event,
                        dateString: formattedDate)

        return cell
    }
}

extension LoggerViewController: InMemoryObserverProtocol {
    func eventRecieved(event: Event,
                       eventsList: [Event]) {
        dataSource = eventsList
        collectionView.reloadData()
    }
}
