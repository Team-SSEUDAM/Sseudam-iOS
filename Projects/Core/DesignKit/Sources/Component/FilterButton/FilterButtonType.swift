//
//  FilterButtonType.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct FilterButtonType: Hashable, Identifiable {
  public let id = UUID()
  public let title: String
  public let icon: ImageSet?

  public init(title: String, icon: ImageSet? = nil) {
    self.title = title
    self.icon = icon
  }
}
