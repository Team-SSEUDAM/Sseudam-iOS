//
//  Encodable+.swift
//  Utility
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public extension Encodable {
  func toDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    guard let convertedDict = jsonData as? [String: Any] else { throw FoundationError.failedToCasting(from: jsonData, to: [String: Any]()) }
    return convertedDict
  }
}
