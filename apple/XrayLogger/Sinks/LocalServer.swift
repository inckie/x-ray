//
//  LocalServer.swift
//  XrayLogger
//
//  Created by Anton Kononenko on 9/17/21.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import Foundation

public class LocalServer: BaseSink {
    public var syncAfterEachWrite: Bool = false
    let localHostUrlString: String

    public init(localHostUrlString: String) {
        self.localHostUrlString = localHostUrlString
    }

    override public func log(event: Event) {
        let dict = event.toDictionary()
        guard JSONSerialization.isValidJSONObject(dict) else {
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dict,
                                                  options: [])

            let session = URLSession.shared
            guard let url = URL(string: "http://\(localHostUrlString)/postEvent") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
}
