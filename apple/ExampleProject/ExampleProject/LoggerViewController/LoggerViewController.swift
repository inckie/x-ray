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
    let dataSourceHelper = DataSourceHelper()
    @IBOutlet var collectionView: UICollectionView!
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
    public var format = "yyyy-MM-dd'T'HH:mm:ssZ"

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        collectionView?.register(UINib(nibName: "LoggerCell", bundle: nil),
                                 forCellWithReuseIdentifier: cellIdentifier)
        XrayLogger.sharedInstance.addSink(identifier: "LoggerScreen",
                                          sink: self)
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.view.bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(view)
    }

    func loadViewFromNib() -> UIView? {
//        guard let nibName = nibName else { return nil }
        let nibName = "LoggerViewController"
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    public var queue: DispatchQueue = {
        let uuid = NSUUID().uuidString
        let queueLabel = "sink-\(uuid)"
        return DispatchQueue(label: queueLabel)
    }()

    func log(event: Event) {
        let newDataSource = dataSourceHelper.addEvent(event: event)
        if newDataSource.count > dataSource.count {
            dataSource = newDataSource
            collectionView?.reloadData() // SHould insert values not reload all table
        }
    }

    func dateStringFromEvent(event: Event) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(event.timestamp))
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension LoggerViewController: UICollectionViewDelegate, SinkProtocol {
}

extension LoggerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
