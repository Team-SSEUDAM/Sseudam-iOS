//
//  NetworkKitProtocol.swift
//  NetworkKit
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public protocol NetworkKitProtocol {
  /// 네트워크 통신을 위한 execute 메서드
  func execute<E: APIRequestable>(with endpoint: E, timeout: TimeInterval) async throws -> E.Response where E.Response: Decodable & Sendable
  /// 이미지 업로드을 위한 execute 메서드
  func upload(with url: String, data: Data, timeout: TimeInterval) async throws -> Void
  /// Task의 checkCancellation를 통해, 네트워크 통신 도중의 cancel을 체크할 수 있음
  func executeWithTask<E: APIRequestable>(with endpoint: E, timeout: TimeInterval) -> Task<E.Response, Error> where E.Response: Decodable & Sendable
}
