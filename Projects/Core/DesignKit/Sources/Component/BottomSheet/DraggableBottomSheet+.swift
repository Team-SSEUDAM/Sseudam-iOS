//
//  DraggableBottomSheet+.swift
//  DesignKit
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

extension View {
  public func draggableBottomSheet<SmallContent: View, LargeContent: View>(
    isPresented: Binding<Bool>,
    smallHeight: CGFloat = 350,
    largeHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) -> some View {
    self.background(
      DraggableBottomSheet(
        isPresented: isPresented,
        smallHeight: smallHeight,
        largeHeight: largeHeight,
        smallContent: smallContent,
        largeContent: largeContent
      )
    )
  }
}
