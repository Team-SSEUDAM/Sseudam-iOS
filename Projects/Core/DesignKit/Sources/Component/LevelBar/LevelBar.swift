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
  @Binding private var startAnimation: Bool
  
  /// 애니메이션된 진행도
  @State private var animatedProgress: CGFloat = 0
  /// 화면에 보여지는 레벨
  @State private var displayLevel: CatLevel
  /// 뷰가 나타났는지 여부
  @State private var hasAppeared = false
  /// 애니메이션이 실행되었는지 여부
  @State private var hasAnimated = false
  /// 레벨업 중인지 여부
  @State private var isLevelingUp = false
  
  /// - Parameters:
  ///   - currentLevel: 현재 레벨
  ///   - currentPoint: 현재 가지고 있는 포인트
  ///   - addPoint: 추가 될 포인트
  ///   - maxLevelPoint: 현재 레벨의 포인트 최대치
  ///   - startAnimation: 애니메이션 시작 여부
  public init(
    currentLevel: CatLevel,
    currentPoint: Int,
    addPoint: Int = 0,
    maxLevelPoint: Int,
    startAnimation: Binding<Bool>
  ) {
    self.currentLevel = currentLevel
    self.currentPoint = currentPoint
    self.addPoint = addPoint
    self.maxLevelPoint = maxLevelPoint
    self._startAnimation = startAnimation
    self._displayLevel = State(initialValue: .level1)
  }
  
  private var initialProgress: CGFloat {
    guard maxLevelPoint > 0 else { return 0 }
    return CGFloat(currentPoint) / CGFloat(maxLevelPoint)
  }
  
  private var finalProgress: CGFloat {
    guard maxLevelPoint > 0 else { return 0 }
    return CGFloat(currentPoint + addPoint) / CGFloat(maxLevelPoint)
  }
  
  /// 레벨업 가능 여부
  private var willLevelUp: Bool {
    guard currentLevel != .level5 else { return false }
    return currentPoint + addPoint >= maxLevelPoint
  }
  
  /// 레벨업 후 남은 올려야 할 남은 포인트
  private var remainingPointAfterLevelUp: Int {
    guard willLevelUp else { return 0 }
    return (currentPoint + addPoint) - maxLevelPoint
  }
  
  private var isMaxLevel: Bool {
    return currentLevel == .level5
  }
  
  
  public var body: some View {
    HStack(spacing: .Number6) {
      Text("Lv.\(displayLevel.rawInt.description)")
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
    }
    .onChange(of: startAnimation) { oldValue, newValue in
      guard newValue && !oldValue && !hasAnimated && addPoint > 0 else { return }
      hasAnimated = true
      startLevelAnimation()
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
  
  // MARK: - Animation Logic
  
  private func startLevelAnimation() {
    if isMaxLevel { // Level 5인 경우 최대치까지만 애니메이션
      let maxProgress: CGFloat = 1.0
      withAnimation(.easeInOut(duration: 1.0)) {
        animatedProgress = min(finalProgress, maxProgress)
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        startAnimation = false
      }
    } else if willLevelUp {
      
      performLevelUpAnimation()
    } else {
      withAnimation(.easeInOut(duration: 1.0)) {
        animatedProgress = finalProgress
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        startAnimation = false
      }
    }
  }
  
  /// 레벨업 되어 추가 애니메이션이 필요한 경우
  private func performLevelUpAnimation() {
    // 현재 레벨의 최대치까지 채우기
    withAnimation(.easeInOut(duration: 0.6)) {
      animatedProgress = 1.0
    }
    
    // 레벨업 후 남은 포인트로 새로운 progressbar 시작
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
      // 레벨업
      if let newLevel = currentLevel.nextLevel {
        displayLevel = newLevel
        isLevelingUp = true
      }
      
      // progressbar 리셋 후 남은 포인트만큼 채우기
      animatedProgress = 0
      
      let remainingProgress = CGFloat(remainingPointAfterLevelUp) / CGFloat(maxLevelPoint)
      
      withAnimation(.easeInOut(duration: 0.8)) {
        animatedProgress = remainingProgress
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        isLevelingUp = false
        startAnimation = false
      }
    }
  }
  
  
}
