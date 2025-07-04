//
//  SpotSuggestionCompleteView.swift
//  ReportFeature
//
//  Created by 조용인 on 7/1/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct SpotSuggestionCompleteView: View {
  
  private let image: ImageSet
  private let title: String
  private let description: String
  
  public init(
    image: ImageSet,
    title: String,
    description: String
  ) {
    self.image = image
    self.title = title
    self.description = description
  }

  public var body: some View {
    VStack(alignment: .center, spacing: .Number20) {
      Icon(image: image, size: .Number200)
      VStack(spacing: .Number8) {
        Text(title)
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
        Text(description)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
    .padding(.Number16)
    
  }
}

#Preview {
  ReportStartView(
    image: .addSpot,
    title: "발견한 쓰레기통을 제보해주세요!",
    description:
    """
    쓰담이 아직 모르는 쓰레기통이 있나요?
    제보 시 5쓰담이 적립되며,
    승인되면 15쓰담을 추가 적립받아요.
    """
  )
}
