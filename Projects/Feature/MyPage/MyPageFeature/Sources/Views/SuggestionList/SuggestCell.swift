//
//  SuggestCell.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct SuggestCell: View {
  
  public init() {}
  
  public var body: some View {
      HStack(spacing: .Number16) {
        HStack(spacing: .Number12) {
          Image(asset: ImageSet.apple.swiftUIImage)
            .frame(width: .Number56, height: .Number56)
            .clipCorners(.Number8, corners: .allCorners)
          VStack(alignment: .leading, spacing: .Number0) {
            Text("{제보 및 신고 장소에 대한 이름}}")
              .font(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Primary)
              .truncationMode(.tail)
              .lineLimit(1)
            Text("{신규 제보} | {YY.MM.DD.}")
              .font(FontSet.Caption.caption1)
              .foregroundStyle(ColorSet.Text.Tertiary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        Badge(
          text: .constant("{승인 상태}"),
          state: .accent,
        )
      }
      .padding(.vertical, .Number12)
      .padding(.horizontal, .Number16)
      .background(ColorSet.Background.Primary)
    }
}

#Preview {
    SuggestCell()
}
