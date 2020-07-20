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
    @IBOutlet var tableView: UITableView!
    var dataSource: [Event] = []

    var formatter: EventFormatterProtocol?

    var asynchronously: Bool {
        get {
            return false
        }
        set(newValue) {
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        tableView?.register(UINib(nibName: "LoggerCell", bundle: nil),
                            forCellReuseIdentifier: cellIdentifier)

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
            tableView.reloadData() // SHould insert values not reload all table
        }
    }
}

extension LoggerViewController: UITableViewDelegate, SinkProtocol {
}

extension LoggerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! LoggerCell
        let event = dataSource[indexPath.row]
        cell.updateCell(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    

}
