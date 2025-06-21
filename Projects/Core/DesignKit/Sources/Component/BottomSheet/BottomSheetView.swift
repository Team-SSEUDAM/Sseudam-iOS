//
//  BottomSheetView.swift
//  DesignKit
//
//  Created by Jiyeon on 6/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

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
            .padding(.bottom, 20)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipCorners(.Number16, corners: [.topLeft, .topRight])
            .elevation(level: .medium, cornerRadius: .Number16)
            .offset(y: offsetY)
            .allowsHitTesting(true)
        }
      }
      .ignoresSafeArea(edges: .bottom)
  }
}
