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

struct WSMessageEvent: Codable {
  var type: WSMessageType = .event
  let id: UUID
  let event: String
}
