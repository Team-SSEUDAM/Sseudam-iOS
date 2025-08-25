//
//  BottomSheetView.swift
//  DesignKit
//
//  Created by Jiyeon on 6/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

/// ViewModifier를 사용하여 커스텀 바텀시트를 뷰에 오버레이 형태로 적용
///
/// - Parameters:
///   - isPresented: 바텀시트의 표시 여부를 제어하는 바인딩 값
///   - height: 바텀시트의 초기 높이
///   - maxHeight: 바텀시트의 최대 높이. nil일 경우 height 값과 동일하게 설정됨
///   - bottomSheetContent: 바텀시트에 표시할 콘텐츠 뷰
public struct BottomSheetOverlay<BottomSheetContent: View>: ViewModifier {
  @Binding private var isPresented: Bool
  private let height: CGFloat
  private let maxHeight: CGFloat
  private let bottomSheetContent: () -> BottomSheetContent
  
  @State private var offsetY: CGFloat = UIScreen.main.bounds.height
  @State private var showSheet: Bool = false
  
  public init(
    isPresented: Binding<Bool>,
    height: CGFloat,
    maxHeight: CGFloat? = nil,
    bottomSheetContent: @escaping () -> BottomSheetContent
  ) {
    self._isPresented = isPresented
    self.height = height
    self.maxHeight = maxHeight ?? height
    self.bottomSheetContent = bottomSheetContent
  }
  
  public func body(content: Content) -> some View {
    content
      .onChange(of: isPresented) {
        if isPresented {
          showSheet = true
          withAnimation(.easeOut(duration: 0.3)) {
            offsetY = 0
          }
        } else {
          withAnimation(.easeIn(duration: 0.15)) {
            offsetY = height
          }
          Task {
            try? await Task.sleep(for: .seconds(0.15))
            showSheet = false
          }
        }
      }
      .background(.white)
      .overlay(alignment: .bottom) {
        if showSheet {
          bottomSheetContent()
            .frame(height: height)
            .padding(.bottom, .Number10)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipCorners(.Number16, corners: [.topLeft, .topRight])
            .elevation(level: .elevation, cornerRadius: .Number16)
            .offset(y: offsetY)
            .allowsHitTesting(true)
        }
      }
      .ignoresSafeArea(edges: .bottom)
  }
}
