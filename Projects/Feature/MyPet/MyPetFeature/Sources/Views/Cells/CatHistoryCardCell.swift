//
//  CatHistoryCardCell.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit

public struct CatHistoryCardCell: View {
  public let record: CatHistoryCardRecord
  
  public init(
    record: CatHistoryCardRecord
  ) {
    self.record = record
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: .Number10) {
      CatCard
        .aspectRatio(1, contentMode: .fit)
      CatCardInfo
    }
    .padding(.horizontal, .Number8)
    .padding(.top, .Number8)
    .padding(.bottom, .Number12)
    .background(
      RoundedRectangle(cornerRadius: .Number8)
        .inset(by: .Number1)
        .stroke(ColorSet.Border.Secondary, lineWidth: .Number1)
        .fill(ColorSet.Background.Primary)
    ) 
  }
  
  @ViewBuilder
  private var CatCard: some View {
    Rectangle()
      .overlay(
        ZStack {
          VStack(spacing: 0) {
            ColorSet.HexColor._E0F2Ff
            ColorSet.HexColor._9Fd5Fb
          }
          CatImageSet.image(name: record.imageURL)
            .resizable()
            .scaledToFit()
            .padding(.Number14)
        }
      )
      .clipCorners(.Number8, corners: .allCorners)
  }
  
  @ViewBuilder
  private var CatCardInfo: some View {
    VStack(alignment: .center, spacing: .Number6) {
      Badge(
        text: .constant("Lv.\(record.levelType.rawInt)"),
        state: .primary
      )
      CatNicknameView(nickname: record.nickname)
    }
  }
  
  @ViewBuilder
  private func CatNicknameView(
    nickname: String
  ) -> some View {
    let splitNickname = nickname.splitNicknameForTwoLines()
    if let secondLine = splitNickname.second {
      Text(splitNickname.first + "\n" + secondLine)
        .font(FontSet.Title.title4)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
    } else {
      Text(splitNickname.first)
        .font(FontSet.Title.title4)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
    }
  }
}

