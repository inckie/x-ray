//
//  LoggerViewController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/20/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import UIKit
import xray

class LoggerViewController: UIViewController {
    private let cellIdentifier = "LoggerCell"
    private let screenIdentifier = "LoggerScreen"

    @IBOutlet weak var collectionView: UICollectionView!
    private(set) weak var inMemorySink: InMemory?
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
        title = "Logger Screen"
        xibSetup()
        collectionView?.register(UINib(nibName: cellIdentifier,
                                       bundle: nil),
                                 forCellWithReuseIdentifier: cellIdentifier)
        let inMemorySink = InMemory()
        XrayLogger.sharedInstance.addSink(identifier: screenIdentifier,
                                          sink: inMemorySink)
        inMemorySink.addObserver(identifier: screenIdentifier,
                                 item: self)
        self.inMemorySink = inMemorySink
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.view.bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(view)
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
}

extension LoggerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedViewController = DetailedLoggerViewController(nibName: "DetailedLoggerViewController",
                                                                  bundle: nil)
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
                        dateString: formattedDate,
                        width: collectionView.frame.size.width)
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
