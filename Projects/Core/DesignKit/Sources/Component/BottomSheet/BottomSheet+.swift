//
//  BottomSheet+.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

extension View {
  
  
  /// SwiftUI View에 커스텀 바텀시트를 적용할 수 있도록 도와주는 View Extension
  /// 사용 예시:
  /// ```swift
  /// MyView()
  ///   .bottomSheet(isPresented: $isShowing, height: 300, maxHeight: 500) {
  ///     BottomSheetContentView()
  ///   }
  /// ```
  ///
  /// - Parameters:
  ///   - isPresented: 바텀시트의 표시 여부를 제어하는 바인딩 값입니다.
  ///   - height: 바텀시트의 기본 고정 높이입니다.
  ///   - maxHeight: 바텀시트가 최대로 확장될 수 있는 높이입니다. 기본값은 height입니다.
  ///   - content: 바텀시트 내부에 표시할 뷰입니다.
  public func bottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    height: CGFloat,
    maxHeight: CGFloat? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      BottomSheetOverlay(
        isPresented: isPresented,
        height: height,
        maxHeight: maxHeight,
        bottomSheetContent: content
      )
    )
  }
}
