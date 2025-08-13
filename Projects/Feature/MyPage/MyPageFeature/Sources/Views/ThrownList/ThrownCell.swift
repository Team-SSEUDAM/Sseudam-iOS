//
//  ThrownCell.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import VisitedDomainInterface

public struct ThrownCell: View {
  private let thrownList: VisitedListEntity?
  
  public init(
    thrownList: VisitedListEntity? = nil
  ) {
    self.thrownList = thrownList
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      Text(thrownList?.site ?? "")
        .font(FontSet.Body.body2)
        .foregroundStyle(ColorSet.Text.Primary)
        .truncationMode(.tail)
        .lineLimit(1)
      Text(thrownList?.date ?? "")
        .font(FontSet.Caption.caption1)
        .foregroundStyle(ColorSet.Text.Tertiary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, .Number12)
    .padding(.horizontal, .Number16)
    .background(ColorSet.Background.Primary)
  }
}
