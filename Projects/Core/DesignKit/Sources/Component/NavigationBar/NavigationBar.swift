//
//  NavigationBar.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct NavigationBar<BackContent: View, CloseContent: View>: View {
  
  public let backContent: (() -> BackContent)
  public let closeContent: (() -> CloseContent)
  public let title: String?
  
  public init(
    @ViewBuilder backContent: @escaping () -> BackContent = { Spacer().frame(width: .Number48, height: .Number48) },
    title: String? = nil,
    @ViewBuilder closeContent: @escaping () -> CloseContent = { Spacer().frame(width: .Number48, height: .Number48) }
  ) {
    self.backContent = backContent
    self.title = title
    self.closeContent = closeContent
  }
  
  public var body: some View {
    content
  }
  
  @ViewBuilder
  private var content: some View {
    HStack {
      backContent().padding(.leading, .Number4)
      Spacer()
      if let title = title {
        Text(title)
          .font(FontSet.Title.title3)
          .foregroundStyle(ColorSet.Text.Primary)
      }
      Spacer()
      closeContent().padding(.leading, .Number4)
    }
    .background(ColorSet.Background.Primary)
  }
}
