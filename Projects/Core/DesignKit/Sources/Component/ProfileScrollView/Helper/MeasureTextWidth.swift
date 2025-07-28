//
//  MeasureTextWidth.swift
//  DesignKit
//
//  Created by 조용인 on 7/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct TextWidthPreferenceKey: PreferenceKey {
  public static var defaultValue: [String: CGFloat] = [:]

  public static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
    value.merge(nextValue(), uniquingKeysWith: { $1 })
  }
}

public struct MeasureTextWidth: ViewModifier {
  let id: String
  public func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { proxy in
          Color.clear.preference(key: TextWidthPreferenceKey.self, value: [id: proxy.size.width])
        }
      )
  }
}

extension View {
  public func measureTextWidth(for id: String) -> some View {
    self.modifier(MeasureTextWidth(id: id))
  }
}

