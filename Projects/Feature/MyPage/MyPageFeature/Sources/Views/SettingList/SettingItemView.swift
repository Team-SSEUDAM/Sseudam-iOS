//
//  SettingItemView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

/// 설정 화면의 리스트 아이템
struct SettingItemView<Trailing: View>: View {
  
  private let item: SettingType
  private let subTitle: String?
  private let trailingContent: (() -> Trailing)
  private var action: (() async -> Void)? = nil
  
  init(
    item: SettingType,
    subTitle: String? = nil,
    action: (() async -> Void)? = nil,
    @ViewBuilder trailingContent: @escaping (() -> Trailing) = { Spacer() }
  ) {
    self.item = item
    self.subTitle = subTitle
    self.action = action
    self.trailingContent = trailingContent
  }
  
  var body: some View {
    HStack(spacing: .Number8) {
      if let icon = item.icon {
        Icon(image: icon, size: .Number24)
      }
      VStack(alignment: .leading, spacing: .Number2) {
        Text(item.title)
          .font(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        if let subtitle = self.subTitle {
          Text(subtitle)
            .font(FontSet.Caption.caption1)
            .lineSpacing(20)
            .foregroundStyle(ColorSet.Text.Tertiary)
        }
      }
      Spacer()
      trailingContent()
    }
    .padding(.vertical, .Number12)
    .padding(.horizontal, .Number16)
    .contentShape(Rectangle())
    .onTapGesture {
      if let action = action {
        Task { @MainActor in
          await action()
        }
      }
    }
  }
}
