//
//  SearchAreaUseCase.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct SearchAreaUseCase {
  public var execute: @Sendable (String) async throws -> [String]
  
  public init(execute: @Sendable @escaping (String) async throws -> [String]) {
    self.execute = execute
  }
}
