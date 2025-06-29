//
//  URLRequest+.swift
//  Utility
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public extension URLRequest {
  func setMethod(_ method: String) -> URLRequest {
    var urlRequest = self
    urlRequest.httpMethod = method
    return urlRequest
  }
  
  func appendingHeaders(_ headers: [String: String]) -> URLRequest {
    var urlRequest = self
    headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }
    return urlRequest
  }
  
  func setBody(_ body: Data?) throws -> URLRequest {
    var urlRequest = self
    guard let body = body else { throw FoundationError.invalidBody }
    urlRequest.httpBody = body
    return urlRequest
  }
  
  func setBody(_ body: Encodable?, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
    var urlRequest = self
    guard let body = body else { throw FoundationError.invalidBody }
    guard let data = try? encoder.encode(body) else { throw FoundationError.failedToEncode(body) }
    urlRequest.httpBody = data
    return urlRequest
  }
}
