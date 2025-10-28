//
//  NotificationItemView.swift
//  NotificationFeature
//
//  Created by Jiyeon on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import NotificationDomainInterface
import DesignKit
import Utility

public struct NotificationItemView: View {
  private var data: NotificationEntity
  private var onTap: ((NotificationEntity) -> Void)?
  
  private var backgroundColor: Color
  private var textColor: Color
  private var iconColor: Color
  
  init(data: NotificationEntity, onTap: ((NotificationEntity) -> Void)?) {
    self.data = data
    self.onTap = onTap
    backgroundColor = data.readStatus ? ColorSet.Background.Secondary : ColorSet.Background.Primary
    textColor = data.readStatus ? ColorSet.Text.Secondary : ColorSet.Text.Primary
    iconColor = data.readStatus ? ColorSet.Icon.Secondary : ColorSet.Icon.Primary
  }
  
  public var body: some View {
    ZStack {
      backgroundColor
      contentView
      VStack{
        Spacer()
        Rectangle()
          .fill(ColorSet.Border.Secondary)
          .frame(height: .Number1)
      }
    }
  }
  
  @ViewBuilder
  private var contentView: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading, spacing: .Number0) {
        Text(data.contents)
          .font(FontSet.Body.body2)
          .foregroundStyle(textColor)
        Text(data.createdAt.toFormattedDate("yy.MM.dd"))
          .font(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
      }
      Spacer()
      Icon(
        image: .rightChevron,
        size: .Number24,
        renderingMode: .template,
        color: iconColor
      )
    }
    .padding(.vertical, .Number14)
    .padding(.horizontal, .Number16)
    .contentShape(Rectangle())
    .onTapGesture {
      if let onTap = onTap {
        onTap(data)
      }
    }
  }
  
}
