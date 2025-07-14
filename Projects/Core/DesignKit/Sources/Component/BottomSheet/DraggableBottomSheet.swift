//
//  DraggableBottomSheet.swift
//  DesignKit
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//
import SwiftUI

public struct DraggableBottomSheet<SmallContent: View, LargeContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  @Binding var isIgnoreTabbar: Bool
  @State private var selectedDetent: PresentationDetent
  @State private var isAnimating: Bool = false
  
  let smallDetent: PresentationDetent
  let largeDetent: PresentationDetent
  let smallContent: () -> SmallContent
  let largeContent: () -> LargeContent
  
  private var isExpanded: Bool { selectedDetent == largeDetent }
  
  public init(
    isPresented: Binding<Bool>,
    isIgnoreTabbar: Binding<Bool>,
    smallHeight: CGFloat = 350,
    largeHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) {
    self._isPresented = isPresented
    self.smallDetent = .height(smallHeight)
    self.largeDetent = largeHeight != nil ? .height(largeHeight!) : .large
    self._selectedDetent = State(initialValue: .height(smallHeight))
    self.smallContent = smallContent
    self.largeContent = largeContent
    self._isIgnoreTabbar = isIgnoreTabbar
  }
  
  public func body(content: Content) -> some View {
    content
      .sheet(isPresented: $isPresented) {
        ZStack {
          if isExpanded { largeContent() }
          else { smallContent() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .presentationDetents([smallDetent, largeDetent], selection: $selectedDetent)
        .presentationCornerRadius(16)
        .presentationBackground(ColorSet.Background.Primary)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .interactiveDismissDisabled()
        .bottomMaskForSheet(mask: isIgnoreTabbar, 50)
      }
  }
}
