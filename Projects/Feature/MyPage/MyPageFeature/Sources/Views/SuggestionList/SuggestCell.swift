//
//  SuggestCell.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import DesignKit
import SuggestionDomainInterface

public struct SuggestCell: View {
  
  private let suggestion: SuggestionListEntity?
  private let imageData: Data?
  
  @State private var downsampledImage: UIImage?
  
  public init(
    suggestion: SuggestionListEntity? = nil,
    imageData: Data? = nil
  ) {
    self.suggestion = suggestion
    self.imageData = imageData
  }
  
  public var body: some View {
    HStack(spacing: .Number16) {
      HStack(spacing: .Number12) {
        TrashImageView
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
  
  @ViewBuilder
  private var TrashImageView: some View {
    if let image = downsampledImage {
      Image(uiImage: image)
        .resizable()
        .frame(width: .Number56, height: .Number56)
        .clipCorners(.Number8, corners: .allCorners)
    }
    else {
      Rectangle()
        .fill(ColorSet.Background.Secondary)
        .frame(width: .Number56, height: .Number56)
        .clipCorners(.Number8, corners: .allCorners)
        .task(id: imageData) {
          if let data = imageData {
            downsampledImage = await UIImage.downsampledAsync(
              from: data,
              to: CGSize(width: .Number56, height: .Number56)
            )
          }
        }
    }
  }
  
}

#Preview {
    SuggestCell()
}
