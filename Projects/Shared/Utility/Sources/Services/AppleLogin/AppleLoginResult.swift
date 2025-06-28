//
//  AppleLoginResult.swift
//  Utility
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct AppleLoginResult: Equatable, Sendable {
  public let idToken: String
  public let email: String?
  public let name: String?
}
