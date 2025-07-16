//
//  CatCardCell.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct CatCardCell: View {
  public let card: CatCard
  
  public init(
    card: CatCard
  ) {
    self.card = card
  }
  
  public var body: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(card.isLocked ? ColorSet.Background.Tertiary : ColorSet.Gray._100)
      .frame(width: .Number64, height: .Number64)
      .overlay(
        Group {
          if card.isLocked {
            Icon(
              image: .lock,
              size: .Number24,
              renderingMode: .template,
              color: ColorSet.Icon.Tertiary
            )
          } else {
            RoundedRectangle(cornerRadius: 12)
              .fill(ColorSet.Component.Primary.opacity(0.2))
          }
        }
      )
  }
}
