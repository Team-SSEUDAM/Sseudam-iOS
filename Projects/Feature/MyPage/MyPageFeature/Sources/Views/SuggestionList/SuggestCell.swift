//
//  SuggestCell.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import SuggestionDomainInterface

public struct SuggestCell: View {
  
  private let suggestion: SuggestionListEntity?
  
  public init(
    suggestion: SuggestionListEntity? = nil
  ) {
    self.suggestion = suggestion
  }
  
  public var body: some View {
      HStack(spacing: .Number16) {
        HStack(spacing: .Number12) {
          Image(asset: ImageSet.apple.swiftUIImage)
            .frame(width: .Number56, height: .Number56)
            .clipCorners(.Number8, corners: .allCorners)
          VStack(alignment: .leading, spacing: .Number0) {
            Text(suggestion?.address ?? "{주소}")
              .font(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Primary)
              .truncationMode(.tail)
              .lineLimit(1)
            Text("{신규 제보} | \(suggestion?.date ?? "{YY.MM.DD}")")
              .font(FontSet.Caption.caption1)
              .foregroundStyle(ColorSet.Text.Tertiary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        Badge(
          text: .constant(suggestion?.status.ko ?? "{상태}"),
          state: suggestion?.status == .approved
          ? .accent : suggestion?.status == .rejected
          ? .error : .primary,
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
