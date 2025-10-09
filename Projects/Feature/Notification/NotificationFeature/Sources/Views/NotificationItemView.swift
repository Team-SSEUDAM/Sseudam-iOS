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
  private var onTap: ((NotificationType) -> Void)?
  
  init(data: NotificationEntity, onTap: ((NotificationType) -> Void)?) {
    self.data = data
    self.onTap = onTap
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
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
          .foregroundStyle(ColorSet.Text.Primary)
        Text(data.date.toFormattedDate("yy.MM.dd"))
          .font(FontSet.Caption.caption1)
          .foregroundStyle(ColorSet.Text.Tertiary)
      }
      Spacer()
      Icon(
        image: .rightChevron,
        size: .Number24,
        renderingMode: .template,
        color: ColorSet.Icon.Secondary
      )
    }
    .padding(.vertical, .Number14)
    .padding(.horizontal, .Number16)
    .contentShape(Rectangle())
    .onTapGesture {
      if let onTap = onTap {
        onTap(data.type)
      }
    }
  }
  
}
