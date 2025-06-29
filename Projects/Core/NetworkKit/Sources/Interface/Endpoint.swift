//
//  Endpoint.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct Endpoint<R>: APIRequestable where R: Decodable & Sendable {
  public typealias Response = R
  
  public let headers: APIHeaderType
  public let method: HTTPMethod
  public let baseURL: URL?
  public let path: String
  public let parameters: HTTPRequestParameter?
  public let isRefreshToken: Bool
  public let isNotSseudamAPI: Bool
  
  public init(
    headers: APIHeaderType = .plain,
    method: HTTPMethod,
    baseURL: String = Constants.base_url ?? "",
    path: String,
    parameters: HTTPRequestParameter? = nil,
    isRefreshToken: Bool = false,
    isNotSseudamAPI: Bool = false
  ) {
    self.headers = headers
    self.method = method
    self.baseURL = URL(string:baseURL)
    self.path = path
    self.parameters = parameters
    self.isRefreshToken = isRefreshToken
    self.isNotSseudamAPI = isNotSseudamAPI
  }
}

public extension Endpoint {
  static func presignedURL(_ url: String, with data: Data) -> Endpoint<EmptyResponse> {
    return .init(
      headers: .custom([
        "Content-Type": "image/jpeg"
      ]),
      method: .put,
      baseURL: url,
      path: "",
      parameters: .rawData(data)
    )
  }
}
  
