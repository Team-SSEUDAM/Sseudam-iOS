//
//  APIRequestable.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public typealias HTTPHeaders = [String: String]
public typealias HTTPParameters = [String: Any]


public enum APIHeaderType {
  case plain
  case authorization(String?)
  case custom([String: String])
}

public enum HTTPRequestParameter {
  case query(_ query: Encodable?)
  case body(_ parameter: Encodable?)
  case rawData(_ data: Data)
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

public protocol APIRequestable {
  associatedtype Response: Decodable & Sendable
  
  var baseURL: URL? { get }
  var method: HTTPMethod { get }
  var headers: APIHeaderType { get }
  var path: String { get }
  var parameters: HTTPRequestParameter? { get }
  var isRefreshToken: Bool { get }
  var isNotSseudamAPI: Bool { get }
  
  func toURLRequest() throws -> URLRequest
}

public extension APIRequestable {
  var headers: APIHeaderType { .plain }
  var isRefreshToken: Bool { return false }
  var isNotSseudamAPI: Bool { return false }
  
  func toURLRequest() throws -> URLRequest {
    let url = try configureURL()
    var urlRequest = URLRequest(url: url)
      .setMethod(self.method.rawValue)
      .appendingHeaders(configureHeaders())
    if let parameters = self.parameters {
      switch parameters {
      case let .rawData(data): urlRequest = try urlRequest.setBody(data)
      case let .body(body): urlRequest = try urlRequest.setBody(body)
      case .query: break
      }
    }
    return urlRequest
  }
  
  fileprivate func configureURL() throws -> URL {
    guard let baseURL = baseURL else { throw FoundationError.thisValueIsNil(baseURL) }
    var url = baseURL.appendingPathComponent(path)
    if let parameters = parameters {
      switch parameters {
      case let .query(queries): url = try url.appendingQueries(queries)
      default: break
      }
    }
    return url
  }
  
  fileprivate func configureHeaders() -> HTTPHeaders {
    switch headers {
    case let .custom(customHeaders):
      return customHeaders
    case .plain:
      return ["Content-Type": "application/json"]
    case let .authorization(token):
      guard let token = token else { return ["Content-Type": "application/json"] }
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(token)"
      ]
    }
  }
}
