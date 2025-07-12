//
//  SettingItemListView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct SettingItemListView<Content: View>: View {
  var title: String? = nil
  let content: (() -> Content)
  
  init(
    title: String? = nil,
    @ViewBuilder content: @escaping () -> Content = { Spacer() }
  ) {
    self.title = title
    self.content = content
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: .Number0) {
      if let title = title {
        sectionTitle(title)
      }
      content()
    }
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(FontSet.Body.body3)
      .foregroundStyle(ColorSet.Text.Secondary)
      .padding(.top, .Number8)
      .padding(.bottom, .Number4)
      .padding(.horizontal, .Number16)
    
  }
}

