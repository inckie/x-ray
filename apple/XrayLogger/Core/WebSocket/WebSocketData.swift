//
//  WebSocketData.swift
//  XrayLogger
//
//  Created by Alex Zchut on 19/05/2022.
//

import Foundation

enum WSMessageType: String, Codable {
    // Client to server types
    case event
    // Server to client types
    case handshake
    // Command event to client
    case command
    case storage
}

struct WSMessageTypeData: Codable {
    let type: WSMessageType
}

struct WSCommand: Codable {
    var type: WSMessageType = .command
    let command: String
}

struct WSHandshake: Codable {
    let id: UUID
}

struct WSStorage: Codable {
    let id: UUID
    var type: WSMessageType = .storage
    let data: [String:[String:[String:String]]]
}

struct WSMessageEvent: Codable {
    var type: WSMessageType = .event
    let id: UUID
    let event: String
}

