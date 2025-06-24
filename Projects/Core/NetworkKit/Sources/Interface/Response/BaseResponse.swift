//
//  BaseResponse.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct APIResponse<R>: Decodable & Sendable where R: Decodable & Sendable {
  public let success: Bool
  public let status: Int
  public let timestamp: String
  public let data: R
  
  public var isSuccess: Bool { success && (200..<300).contains(status) }
}
