//
//  DeleteAddressListUseCase.swift
//  UserDomainInterface
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct DeleteAreaListUseCase {
  public var execute: @Sendable () async throws -> Void
  
  public init(execute: @Sendable @escaping () async throws -> Void) {
    self.execute = execute
  }
}
