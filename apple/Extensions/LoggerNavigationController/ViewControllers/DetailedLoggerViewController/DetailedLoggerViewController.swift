//
//  DetailedLoggerViewController.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import AccordionSwift
import Reporter
import UIKit
import XrayLogger

class DetailedLoggerViewController: DetailedLoggerBaseViewController {
    let numberOfSections = 5 // Currently no Exception supported
    let numberOfRowsInSection = 2

    struct CellIdentifier {
        static let parent = "EventParentCell"
        static let item = "EventItemCell"
    }

    struct CustomValues {
        static let noContent = "no content found"
    }

    // MARK: - Typealias

    typealias ParentCellModel = Parent<EventParent, EventItem>
    typealias ChildCellModel = EventItem

    typealias ParentCellConfig = CellViewConfig<ParentCellModel, EventParentCell>
    typealias ChildCellConfig = CellViewConfig<ChildCellModel, EventItemCell>

    // MARK: - Properties

    /// The Data Source Provider with the type of DataSource and the different models for the Parent and Child cell.
    var dataSourceProvider: DataSourceProvider<DataSource<ParentCellModel>, ParentCellConfig, ChildCellConfig>?

    @IBAction func readJSON(_ sender: UIBarButtonItem) {
        let bundle = Bundle(for: type(of: self))
        let detailedViewController = DetailedLoggerJSONViewController(nibName: "DetailedLoggerJSONViewController",
                                                                      bundle: bundle)
        detailedViewController.event = event
        detailedViewController.loggerType = loggerType
        detailedViewController.dateString = dateString
        navigationController?.pushViewController(detailedViewController,
                                                 animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configDataSourceForEvent()

        prepareUI()
        title = "Event Details"
    }
}
