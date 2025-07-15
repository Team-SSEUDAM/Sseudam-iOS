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
  private var midHeight: CGFloat { (minHeight + maxHeight) / 2 }

  public init(
    minHeight: CGFloat,
    maxHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight ?? UIScreen.main.bounds.height * 0.8
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
      RoundedRectangle(cornerRadius: 2)
        .fill(ColorSet.Gray._200)
        .frame(width: 80, height: 4)
        .padding(.vertical, 8)
      
      Group {
        if currentHeight < midHeight { smallContent() }
        else { largeContent() }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .frame(height: currentHeight)
    .frame(maxWidth: .infinity)
    .background(ColorSet.Background.Primary)
    .cornerRadius(16)
    .padding(.bottom, 50)
    .highPriorityGesture(dragGesture())
    .animation(isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.8), value: currentHeight)
  }
  
  private func dragGesture() -> some Gesture {
    DragGesture()
      .onEnded { value in
        let dragThreshold: CGFloat = 30 // 30포인트 이상이면 전환
        
        if abs(value.translation.height) > dragThreshold {
          currentHeight = currentHeight < midHeight ? maxHeight : minHeight
        }
      }
  }
}
