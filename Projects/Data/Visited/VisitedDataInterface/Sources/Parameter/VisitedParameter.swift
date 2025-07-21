//
//  VisitedParameter.swift
//  VisitedDataInterface
//
//  Created by Jiyeon on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct VisitedParameter: Encodable {
  let user: Int
  
  public init(user: Int) {
    self.user = user
  }
}
