//
//  LocalServer.swift
//  XrayLogger
//
//  Created by Anton Kononenko on 9/17/21.
//  Copyright © 2021 Applicaster. All rights reserved.
//

import Foundation

public class LocalServer: BaseSink {
    var batchSendTimeDelay: TimeInterval = 1
    var batchSendMaxCount = 100
    var timer: Timer?

    let localHostUrlString: String
    var events = [Event]()

    public init(localHostUrlString: String) {
        self.localHostUrlString = localHostUrlString
        super.init()
        asynchronously = false
    }

    override public func log(event: Event) {
        guard localHostUrlString.count > 0 else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.timer?.invalidate()
                self.timer = nil
            }
            return
        }

        events.append(event)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer?.invalidate()

            if self.events.count == self.batchSendMaxCount {
                self.sendBatch()
                return
            }

            self.timer = Timer.scheduledTimer(timeInterval: self.batchSendTimeDelay,
                                              target: self,
                                              selector: #selector(self.sendBatch),
                                              userInfo: nil,
                                              repeats: false)
        }
    }

    @objc public func sendBatch() {
        queue.sync { [weak self] in
            guard let self = self else { return }

            guard !self.events.isEmpty else { return }

            let mappedEvents = self.events.map { $0.toDictionary() }
            self.events = []
            guard JSONSerialization.isValidJSONObject(mappedEvents) else {
                return
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: mappedEvents,
                                                      options: [])

                let session = URLSession.shared
                guard let url = URL(string: "http://\(self.localHostUrlString)/postBatchEvents") else {
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                request.httpBody = data

                let task = session.dataTask(with: request) { _, _, error in
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
}
