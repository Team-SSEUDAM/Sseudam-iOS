//
//  DayStatusIcon.swift
//  DesignKit
//
//  Created by Jiyeon on 7/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct DayStatusIcon: View {
  
  private let day: String
  private let status: DayStatus
  
  public init(
    day: String,
    status: DayStatus
  ) {
    self.day = day
    self.status = status
  }
  
  public var body: some View {
    VStack(spacing: .Number0) {
      Icon(image: status.icon, size: .Number40)
      Text(day)
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
    }
    .padding(.Number8)
  }
}
