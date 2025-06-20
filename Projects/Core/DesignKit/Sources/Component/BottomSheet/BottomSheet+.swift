//
//  BottomSheet+.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

extension View {
  public func bottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    height: CGFloat,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      BottomSheetOverlay(
        isPresented: isPresented,
        height: height,
        bottomSheetContent: content
      )
    )
  }
}
