//
//  ErrorResponse.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Sendable {
  public let code: String
  public let message: String
}
