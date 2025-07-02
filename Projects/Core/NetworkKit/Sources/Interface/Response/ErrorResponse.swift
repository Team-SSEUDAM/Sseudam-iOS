//
//  ErrorResponse.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Sendable {
  public let success: Bool
  public let status: Int
  public let data: Result
  public let timestamp: String
  
  public struct Result: Decodable, Sendable {
    public let errorClassName: String
    public let message: String
  }
}
