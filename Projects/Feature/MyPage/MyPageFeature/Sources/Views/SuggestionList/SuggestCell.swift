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
import HistoryDomainInterface

public struct SuggestCell: View {
  
  private let history: SuggestionAndReportHistoryEntity?
  private let imageData: Data?
  
  @State private var downsampledImage: UIImage?
  
  public init(
    history: SuggestionAndReportHistoryEntity? = nil,
    imageData: Data? = nil
  ) {
    self.history = history
    self.imageData = imageData
  }
  
  public var body: some View {
    HStack(spacing: .Number16) {
      HStack(spacing: .Number12) {
        TrashImageView
        VStack(alignment: .leading, spacing: .Number0) {
          Text(history?.address ?? "{주소}")
            .font(FontSet.Body.body2)
            .foregroundStyle(ColorSet.Text.Primary)
            .truncationMode(.tail)
            .lineLimit(1)
          Text("\((history?.actionType == .suggestion ? "신규 제보" : "수정 제안")) | \(history?.date ?? "{YY.MM.DD}")")
            .font(FontSet.Caption.caption1)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      Badge(
        text: .constant(history?.status.ko ?? "{상태}"),
        state: history?.status == .approved
        ? .accent : history?.status == .rejected
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
