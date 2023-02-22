//
//  Data+Extensions.swift
//  XrayLogger
//
//  Created by Alex Zchut on 22/02/2023.
//

import CryptoKit
import Foundation

extension Data {
    var md5: String {
        Insecure.MD5
            .hash(data: self)
            .map { String(format: "%02x", $0) }
            .joined()
    }
}
