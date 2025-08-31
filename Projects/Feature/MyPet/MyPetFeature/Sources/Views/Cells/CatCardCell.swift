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
    Rectangle()
      .fill(card.isLocked ? ColorSet.Background.Tertiary : ColorSet.Gray._100)
      .frame(width: .Number64, height: .Number64)
      .overlay(
        ZStack {
          if card.isLocked {
            Icon(
              image: .lock,
              size: .Number24,
              renderingMode: .template,
              color: ColorSet.Icon.Tertiary
            )
          } else {
            VStack(spacing: 0) {
              ColorSet.HexColor._E0F2Ff
              ColorSet.HexColor._9Fd5Fb
            }
            CatImageSet.image(name: card.imageURL)
              .resizable()
              .scaledToFit()
              .frame(width: .Number50, height: .Number50)
          }
        }
      )
      .clipCorners(.Number8, corners: .allCorners)
      .opacity(card.isLocked ? 0.4 : 1.0)
  }
}
