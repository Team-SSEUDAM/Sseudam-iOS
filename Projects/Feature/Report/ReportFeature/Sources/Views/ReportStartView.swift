//
//  ReportView.swift
//
//  ReportStartView
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct ReportStartView: View {
  
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
          .multilineTextAlignment(.center)
        Text(description)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
    .padding(.Number16)
    
  }
}
