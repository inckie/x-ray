//
//  DefaultEventFormatter.swift
//  xray
//
//  Created by Anton Kononenko on 7/15/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class DefaultEventFormatter: EventFormatterProtocol {
    public func format(event: Event) -> String {
        var retVal = "message: \(event.message) \n"
        if let dataString = parseDictionary(headerName: "Data", dict: event.data) {
            retVal += dataString
        }

        if let dataString = parseDictionary(headerName: "Context", dict: event.data) {
            retVal += dataString
        }
        return retVal
    }

    private func parseDictionary(headerName: String, dict: [String: Any]?) -> String? {
        var retVal: String?
        guard let dict = dict,
            dict.isEmpty == false else {
            return retVal
        }

        retVal = "\(headerName):\n"
        dict.forEach { item in
            retVal = "   \(item.key): \(item.value)"
        }

        return retVal
    }

    private func parseException(exception: NSException?) -> String? {
        guard let exception = exception else {
            return nil
        }
        var retVal = "Exception:\n"
        let symbols = exception.callStackSymbols
        retVal += "CallStackSymbols:\n"
        symbols.forEach { symbol in
            retVal = "   \(symbol)"
        }
        retVal += "Name:\n"
        retVal += "   \(exception.name)"

        if let reason = exception.reason {
            retVal += "Reason:\n"
            retVal += "   \(reason)"
        }

        if let userInfoString = parseDictionary(headerName: "UserInfo", dict: exception.userInfo as? [String: Any]) {
            retVal += userInfoString
        }
        return retVal
    }
}
