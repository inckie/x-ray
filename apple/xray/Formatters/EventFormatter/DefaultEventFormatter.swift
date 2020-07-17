//
//  DefaultEventFormatter.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

private let defaultChildrenSpacing = 5
public class DefaultEventFormatter: EventFormatterProtocol {
    public var skipData: Bool = true
    public var skipContext: Bool = true
    public var skipeException: Bool = false
    let dateFormatter = DateFormatter()
    public var format = "yyyy-MM-dd'T'HH:mm:ssZ"
    public func format(event: Event) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(event.timestamp))
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        let projectName = Bundle.main.infoDictionary?["CFBundleName"] ?? ""
        let callerPlace = parseLineString(event: event)

        var retVal = "\(dateString) | \(event.level.toString()): \(projectName) \(callerPlace) \(event.message) \n"

        if skipData == false,
            let dataString = parseDictionary(headerName: "data",
                                             dict: event.data) {
            retVal += dataString
        }

        if skipContext == false,
            let contextString = parseDictionary(headerName: "context",
                                                dict: event.context) {
            retVal += contextString
        }

        if skipeException,
            let exceptionString = parseException(exception: event.exception) {
            retVal += exceptionString
        }

        return retVal
    }

    private func parseDictionary(headerName: String,
                                 dict: [String: Any]?,
                                 childrenSpacing: Int = defaultChildrenSpacing) -> String? {
        guard let dict = dict,
            dict.isEmpty == false else {
            return nil
        }

        var retVal = "  \(headerName):\n"
        dict.forEach { item in
            retVal += String(repeating: " ", count: childrenSpacing)

            if let dict = item.value as? [String: Any],
                let dictString = parseDictionary(headerName: item.key,
                                                 dict: dict,
                                                 childrenSpacing: childrenSpacing + defaultChildrenSpacing) {
                retVal += "\(dictString)"

            } else if let array = item.value as? [Any],
                let arrayToString = parseArray(headerName: item.key,
                                               array: array,
                                               childrenSpacing: childrenSpacing + defaultChildrenSpacing) {
                retVal += "\(arrayToString)"

            } else {
                retVal += "\(item.key): \(item.value)\n"
            }
        }
        return retVal
    }

    private func parseArray(headerName: String,
                            array: [Any]?,
                            childrenSpacing: Int = 3) -> String? {
        guard let array = array,
            array.isEmpty == false else {
            return nil
        }

        var retVal = headerName.count > 0 ? "  \(headerName): [\n" : "  [\n"
        array.forEach { item in
            retVal += String(repeating: " ", count: childrenSpacing)

            if let dict = item as? [String: Any],
                let dictString = parseDictionary(headerName: "dictionary",
                                                 dict: dict,
                                                 childrenSpacing: childrenSpacing + defaultChildrenSpacing) {
                retVal += "\(dictString)"

            } else if let array = item as? [Any],
                let arrayToString = parseArray(headerName: "array",
                                               array: array,
                                               childrenSpacing: childrenSpacing + defaultChildrenSpacing) {
                retVal += "\(arrayToString)"

            } else {
                retVal += "\(item)\n"
            }
        }
        retVal += String(repeating: " ", count: childrenSpacing - defaultChildrenSpacing) + "]\n"
        return retVal
    }

    private func parseException(exception: NSException?) -> String? {
        guard let exception = exception else {
            return nil
        }
        var retVal = "exception:\n"
        let symbols = exception.callStackSymbols
        retVal += "call_stack_symbols:\n"
        symbols.forEach { symbol in
            retVal = "   \(symbol)"
        }
        retVal += "name:\n"
        retVal += "   \(exception.name)"

        if let reason = exception.reason {
            retVal += "reason:\n"
            retVal += "   \(reason)"
        }

        if let userInfoString = parseDictionary(headerName: "user_info", dict: exception.userInfo as? [String: Any]) {
            retVal += userInfoString
        }
        return retVal
    }

    func parseLineString(event: Event) -> String {
        guard let data = event.data,
            let location = data["location"] as? [String: Any],
            let lineNumber = location["line"],
            let functionName = location["function"] else {
            return ""
        }
        return "[\(functionName):\(lineNumber)]"
    }
}
