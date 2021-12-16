//
//  LoggerHelper+ContextMenu.swift
//  LoggerInfo
//
//  Created by Alex Zchut on 16/12/2021.
//

import AccordionSwift
import Foundation

extension LoggerHelper {
    public typealias ChildContextMenuData = (tableView: UITableView, indexPath: IndexPath, model: EventItem?)
    public typealias ParentContextMenuData = (tableView: UITableView, indexPath: IndexPath, model: Parent<EventParent, EventItem>?)

    struct Params {
        struct Action {
            static let copy = "Copy"
        }

        struct ActionIcon {
            static let copy = "doc.on.doc"
        }
    }

    public static func createContextMenuConfiguration(forChild data: ChildContextMenuData,
                                                      in dataSource: DataSource<Parent<EventParent, EventItem>>) -> UIContextMenuConfiguration? {
        guard #available(iOS 13, *) else {
            return nil
        }

        let identifier = "\(data.indexPath.section)-\(data.model?.name ?? "")" as NSString

        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in

            let copyAction = UIAction(
                title: Params.Action.copy,
                image: UIImage(systemName: Params.ActionIcon.copy)) { _ in

                guard let item = data.model else {
                    return
                }
                    
                LoggerHelper.copyAction(forItem: item,
                                        completion: { result in
                                            switch result {
                                            case .success:
                                                break
                                            case .failure:
                                                break
                                            }
                                        })
            }

            return UIMenu(title: data.model?.name ?? "", image: nil, children: [copyAction])
        }
    }
}
