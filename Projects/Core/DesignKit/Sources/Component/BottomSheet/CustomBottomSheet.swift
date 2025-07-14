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
    maxHeight: CGFloat,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.smallContent = smallContent
    self.largeContent = largeContent
    // 시작 시에는 minHeight
    self._currentHeight = State(initialValue: minHeight)
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      sheetView
        .transition(.move(edge: .bottom))
    }
    .ignoresSafeArea()
  }
  
  private var sheetView: some View {
    GeometryReader { proxy in
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
      .animation(isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.8), value: currentHeight)
      .frame(maxWidth: .infinity)
      .frame(maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, proxy.safeAreaInsets.bottom + 50)
      .background(Color.white)
      .cornerRadius(16)
      .gesture(dragGesture(in: proxy))
    }
  }
  
  private func dragGesture(in proxy: GeometryProxy) -> some Gesture {
    DragGesture()
      .onChanged { value in
        if !isDragging {
          isDragging = true
          initialHeight = currentHeight
        }
        let translation = value.translation.height
        let newHeight = initialHeight - translation
        
        if newHeight > maxHeight { currentHeight = maxHeight + (newHeight - maxHeight) * 0.1 }
        else if newHeight < minHeight { currentHeight = minHeight - (minHeight - newHeight) * 0.1 }
        else { currentHeight = newHeight }
      }
      .onEnded { value in
        isDragging = false
        let target = (initialHeight - value.translation.height) > midHeight
        ? maxHeight
        : minHeight
        currentHeight = target
      }
  }
}
