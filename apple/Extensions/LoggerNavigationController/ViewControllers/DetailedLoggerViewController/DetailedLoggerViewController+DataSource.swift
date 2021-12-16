//
//  DetailedLoggerViewController+DataSource.swift
//  LoggerInfo
//
//  Created by Alex Zchut on 07/12/2021.
//

import AccordionSwift
import XrayLogger

extension DetailedLoggerViewController {
    /// Configure the data source
    func configDataSourceForEvent() {
        guard let event = event else {
            return
        }

        var sections: [Section<Parent<EventParent, EventItem>>] = []
        var groups: [Parent<EventParent, EventItem>] = []
        groups.append(Parent(state: .expanded,
                             item: EventParent(name: DetailedLoggerSections.message.toString()),
                             children: [EventItem(name: event.message)]))

        if !event.category.isEmpty {
            groups.append(Parent(state: .expanded,
                                 item: EventParent(name: DetailedLoggerSections.category.toString()),
                                 children: [EventItem(name: event.category)]))
        }

        if !event.subsystem.isEmpty {
            groups.append(Parent(state: .expanded,
                                 item: EventParent(name: DetailedLoggerSections.subsystem.toString()),
                                 children: [EventItem(name: event.subsystem)]))
        }

        sections.append(Section(groups, headerTitle: "Main info"))

        if let data = event.data, !data.isEmpty {
            var dataGroups: [Parent<EventParent, EventItem>] = []
            for (dataKey, dataValue) in data {
                if !"\(dataValue)".isEmpty {
                    var valueJsonString: String?
                    if let extendableValue = dataValue as? [String: Any],
                       extendableValue.count > 0 {
                        valueJsonString = JSONHelper.convertObjectToJSONString(object: extendableValue)
                    }
                    let parent = Parent(state: .expanded,
                                        item: EventParent(name: dataKey),
                                        children: [EventItem(name: "\(dataValue)",
                                                             parentName: dataKey,
                                                             valueJsonString: valueJsonString)])
                    dataGroups.append(parent)
                }
            }
            sections.append(Section(dataGroups, headerTitle: DetailedLoggerSections.data.toString()))
        }

        if let context = event.context, !context.isEmpty {
            var contextGroups: [Parent<EventParent, EventItem>] = []
            for (contextKey, contextValue) in context {
                if !"\(contextValue)".isEmpty {
                    let parent = Parent(state: .expanded,
                                        item: EventParent(name: contextKey),
                                        children: [EventItem(name: "\(contextValue)")])
                    contextGroups.append(parent)
                }
            }
            sections.append(Section(contextGroups, headerTitle: DetailedLoggerSections.context.toString()))
        }

        let dataSource = DataSource(sections)

        let parentCellConfig = ParentCellConfig(
            reuseIdentifier: CellIdentifier.parent) { (cell, model, _, _) -> EventParentCell in
            cell.keyLabel.text = model?.item.name ?? ""
            cell.backgroundColor = UIColor(hexColor: "#F5F5F5FF")
            cell.selectionStyle = model?.item.name == CustomValues.noContent ? .none : .gray
            return cell
        }

        let childCellConfig = ChildCellConfig(
            reuseIdentifier: CellIdentifier.item) { (cell, item, _, _) -> EventItemCell in
            cell.keyLabel.text = item?.name ?? ""
            cell.selectionStyle = .none
            if let _ = item?.valueJsonString {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }

            return cell
        }

        let didSelectParentCell = { (_: UITableView, _: IndexPath, _: ParentCellModel?) -> Void in
        }

        let didSelectChildCell = { (_: UITableView, _: IndexPath, item: ChildCellModel?) -> Void in
            if let valueJsonString = item?.valueJsonString {
                let bundle = Bundle(for: type(of: self))
                let detailedJsonViewController = DetailedLoggerJSONViewController(nibName: "DetailedLoggerJSONViewController",
                                                                                  bundle: bundle)
                detailedJsonViewController.event = self.event
                detailedJsonViewController.parentTitle = item?.parentName
                detailedJsonViewController.dateString = self.dateString
                detailedJsonViewController.loggerType = self.loggerType
                detailedJsonViewController.dataObject = JSONHelper.convertStringToDictionary(text: valueJsonString)
                self.navigationController?.pushViewController(detailedJsonViewController,
                                                              animated: true)
            }
        }

        let heightForParentCell = { (_: UITableView, _: IndexPath, _: ParentCellModel?) -> CGFloat in
            UITableView.automaticDimension
        }

        let heightForChildCell = { (_: UITableView, _: IndexPath, _: ChildCellModel?) -> CGFloat in
            UITableView.automaticDimension
        }

        let headerHeightForSectionAtIndex = { (_: Int) -> CGFloat in
            36
        }

        let headerViewForSectionAtIndex = { (title: String?, _: Int) -> UIView? in
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .darkGray
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
            titleLabel.translatesAutoresizingMaskIntoConstraints = true
            titleLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]

            return titleLabel
        }

        let footerViewForSectionAtIndex = { (_: String?, _: Int) -> UIView? in
            nil
        }

        let contextMenuConfigurationForChildCellAtIndexPath = { (tableView: UITableView, indexPath: IndexPath, model: EventItem?) -> NSObject? in
            LoggerHelper.createContextMenuConfiguration(forChild: (tableView: tableView, indexPath: indexPath, model: model),
                                                        in: dataSource)
        }

        let contextMenuConfigurationForParentCellAtIndexPath = { (_: UITableView, _: IndexPath, _: ParentCellModel?) -> NSObject? in
            nil
        }

        let configurationProperties = ConfigurationProperties(
            shouldScrollToBottomOfExpandedParent: false
        )

        dataSourceProvider = DataSourceProvider(
            dataSource: dataSource,
            parentCellConfig: parentCellConfig,
            childCellConfig: childCellConfig,
            didSelectParentAtIndexPath: didSelectParentCell,
            didSelectChildAtIndexPath: didSelectChildCell,
            heightForParentCellAtIndexPath: heightForParentCell,
            heightForChildCellAtIndexPath: heightForChildCell,
            contextMenuConfigurationForParentCellAtIndexPath: contextMenuConfigurationForParentCellAtIndexPath,
            contextMenuConfigurationForChildCellAtIndexPath: contextMenuConfigurationForChildCellAtIndexPath,
            headerViewForSectionAtIndex: headerViewForSectionAtIndex,
            footerViewForSectionAtIndex: footerViewForSectionAtIndex,
            headerHeightForSectionAtIndex: headerHeightForSectionAtIndex,
            numberOfExpandedParentCells: .multiple,
            configurationProperties: configurationProperties
        )

        tableView.estimatedRowHeight = 40
        tableView.dataSource = dataSourceProvider?.tableViewDataSource
        tableView.delegate = dataSourceProvider?.tableViewDelegate
        tableView.tableFooterView = UIView()
        let bundle = Bundle(for: type(of: self))
        let nibItem = UINib(nibName: CellIdentifier.item, bundle: bundle)
        let nibParent = UINib(nibName: CellIdentifier.parent, bundle: bundle)
        tableView.register(nibItem, forCellReuseIdentifier: CellIdentifier.item)
        tableView.register(nibParent, forCellReuseIdentifier: CellIdentifier.parent)
    }
}
