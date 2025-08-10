//
//  LevelBar.swift
//  DesignKit
//
//  Created by Jiyeon on 8/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct LevelBar: View {
  
  private var currentLevel: CatLevel
  private var currentPoint: Int
  private var addPoint: Int
  private var maxLevelPoint: Int
  
  @State private var animatedProgress: CGFloat = 0
  @State private var hasAppeared = false
  
  public init(
    currentLevel: CatLevel,
    currentPoint: Int,
    addPoint: Int = 0,
    maxLevelPoint: Int
  ) {
    self.currentLevel = currentLevel
    self.currentPoint = currentPoint
    self.addPoint = addPoint
    self.maxLevelPoint = maxLevelPoint
  }
  
  private var initialProgress: CGFloat {
    guard maxLevelPoint > 0 else { return 0 }
    return CGFloat(currentPoint) / CGFloat(maxLevelPoint)
  }
  
  private var finalProgress: CGFloat {
    guard maxLevelPoint > 0 else { return 0 }
    return CGFloat(currentPoint + addPoint) / CGFloat(maxLevelPoint)
  }
  
  public var body: some View {
    HStack(spacing: .Number6) {
      Text("Lv.\(currentLevel.rawInt.description)")
        .foregroundStyle(ColorSet.Text.Primary)
        .font(FontSet.Body.body3)
        .foregroundColor(.primary)
      
      ProgressBar
    }
    .padding(.horizontal, .Number16)
    .onAppear {
      guard !hasAppeared else { return }
      hasAppeared = true
      
      animatedProgress = initialProgress
      
      if addPoint > 0 {
        withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
          animatedProgress = finalProgress
        }
      }
    }
  }
  
  @ViewBuilder
  private var ProgressBar: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: .Number8)
        .fill(ColorSet.Background.Tertiary)
        .frame(height: .Number8)
      
      GeometryReader { geometry in
        RoundedRectangle(cornerRadius: .Number8)
          .fill(ColorSet.Component.Primary)
          .frame(
            width: max(0, min(geometry.size.width * animatedProgress, geometry.size.width)),
            height: .Number8
          )
          .clipped()
      }
    }
    .frame(width: .Number80, height: .Number8)
  }
  
}
