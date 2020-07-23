//
//  JSONHelper.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

class JSONHelper {
    class func convertObjectToJSONString(object: Any,
                                         options opt: JSONSerialization.WritingOptions = []) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object,
                                                      options: opt)
            let jsonString = String(data: jsonData,
                                    encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }

    class func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
