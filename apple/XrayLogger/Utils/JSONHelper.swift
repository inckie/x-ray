//
//  JSONHelper.swift
//  ExampleProject
//
//  Created by Anton Kononenko on 7/21/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class JSONHelper {
    public class func convertObjectToJSONString(object: Any,
                                         options opt: JSONSerialization.WritingOptions = .prettyPrinted) -> String? {
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

    public class func convertStringToDictionary(text: String) -> [String: AnyObject]? {
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
    
    @discardableResult
    public class func writeObjectToFile(object: Any, at url:URL) -> Bool {
        var retValue = false
        do {
            let data = try JSONSerialization.data(withJSONObject: object,
                                                  options: [])
            try data.write(to: url,
                           options: [])
            retValue = true

        } catch let error {
            print(error)
        }
        return retValue
    }
}
