//
//  LocalServer.swift
//  XrayLogger
//
//  Created by Alex Zchut on 05/19/22.
//  Copyright © 2022 Applicaster. All rights reserved.
//

import Foundation

public class WebSocket: BaseSink {
    enum ErrorCodes: Int {
        case undefined
        case notConnected = 57
    }
    var socket: URLSessionWebSocketTask?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    let localHostUrlString: String

    public init(localHostUrlString: String) {
        self.localHostUrlString = localHostUrlString
        super.init()
        asynchronously = false
        connect()
    }

    override public func log(event: Event) {
        guard localHostUrlString.count > 0,
            let eventJsonString = event.toJSONString() else {
            return
        }
        
        do {
            let message = WSMessageEvent(id: UUID(), event: eventJsonString)
            let data = try encoder.encode(message)

            socket?.send(.data(data)) { err in
                if err != nil,
                    let error = err as? NSError {
                    if let knownError = ErrorCodes.init(rawValue: error.code) {
                        switch knownError {
                        case .notConnected:
                            self.connect()
                            self.log(event: event)
                        default:
                            break
                        }
                    }
                    else {
                        print(err.debugDescription)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func connect() {
        let session = URLSession.shared
        socket = session.webSocketTask(with: URL(string: localHostUrlString)!)
        listen()
        socket?.resume()
    }

    func listen() {
        socket?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                print(error)
                return
            case let .success(message):
                switch message {
                case let .data(data):
                    self.handle(data)
                case let .string(str):
                    guard let data = str.data(using: .utf8) else { return }
                    self.handle(data)
                @unknown default:
                    break
                }
            }
            self.listen()
        }
    }

    func handle(_ data: Data) {
        do {
            let sinData = try JSONDecoder().decode(WSMessageTypeData.self, from: data)
            switch sinData.type {
            case .handshake:
                let message = try JSONDecoder().decode(WSHandshake.self, from: data)
                print("WebSocketHandshake message id: \(message.id)")
            default:
                break
            }
        } catch let error {
            print(error)
        }
    }
}
