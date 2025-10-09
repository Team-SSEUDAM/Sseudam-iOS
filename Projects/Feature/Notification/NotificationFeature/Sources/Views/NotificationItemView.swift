//
//  NotificationItemView.swift
//  NotificationFeature
//
//  Created by Jiyeon on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct NotificationItemView: View {
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
        Text("ㅇㅇ님이 제보한\n쓰레기통에 쓰레기가 버려졌어요.")
          .font(FontSet.Body.body2)
          .foregroundStyle(ColorSet.Text.Primary)
        Text("25.01.01")
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
  }
  
}
