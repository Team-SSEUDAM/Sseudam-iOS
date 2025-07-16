//
//  CustomBottomSheet.swift
//  DesignKit
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct CustomBottomSheet<SmallContent: View, LargeContent: View>: View {
  
  // 시트 크기 경계
  let minHeight: CGFloat
  let maxHeight: CGFloat
  
  // 두 가지 상태의 콘텐츠
  let smallContent: () -> SmallContent
  let largeContent: () -> LargeContent
  
  // 내부 상태
  @State private var currentHeight: CGFloat
  @State private var isDragging: Bool = false
  @State private var initialHeight: CGFloat = 0
  
  // 중간 임계값 (콘텐츠 전환 기준)
  private let midHeight: CGFloat

  public init(
    minHeight: CGFloat,
    maxHeight: CGFloat? = nil,
    midHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight ?? UIScreen.main.bounds.height * 0.8
    self.midHeight = midHeight ?? (minHeight + (maxHeight ?? UIScreen.main.bounds.height * 0.8)) / 2
    self.smallContent = smallContent
    self.largeContent = largeContent
    // 시작 시에는 minHeight
    self._currentHeight = State(initialValue: minHeight)
  }
  
  public var body: some View {
    VStack {
      Spacer()
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .allowsHitTesting(false)
      sheetView
    }
    .ignoresSafeArea()
  }
  
  private var sheetView: some View {
    VStack(spacing: 0) {
      VStack {
        RoundedRectangle(cornerRadius: 2)
          .fill(ColorSet.Gray._200)
          .frame(width: 80, height: 4)
          .padding(.vertical, 8)
      }
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
      .frame(height: .Number20)
      .onTapGesture {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
          currentHeight = currentHeight < midHeight ? maxHeight : minHeight
        }
      }
      
      Group {
        if currentHeight < midHeight { smallContent() }
        else { largeContent() }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .frame(height: currentHeight)
    .frame(maxWidth: .infinity)
    .background(ColorSet.Background.Primary)
    .clipCorners(.Number16, corners: [.topLeft, .topRight])
    .elevation(level: .small, cornerRadius: .Number16)
    .highPriorityGesture(dragGesture())
  }
  
  private func dragGesture() -> some Gesture {
    DragGesture(coordinateSpace: .global)
      .onChanged { value in
        if !isDragging {
          isDragging = true
          initialHeight = currentHeight
        }
        
        let translation = value.translation.height
        if translation > 0 { currentHeight = max(minHeight, initialHeight - abs(translation)) }
        else { currentHeight = min(maxHeight, initialHeight + abs(translation)) }
      }
      .onEnded { value in
        isDragging = false
        let velocity = CGSize(
          width:  value.predictedEndLocation.x - value.location.x,
          height: value.predictedEndLocation.y - value.location.y
        )
        
        if abs(velocity.height) > 450 {
          if velocity.height > 0 { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentHeight = minHeight } }
          else { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentHeight = maxHeight } }
        } else {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentHeight = initialHeight - value.translation.height > midHeight ? maxHeight : minHeight }
        }
      }
  }
}
