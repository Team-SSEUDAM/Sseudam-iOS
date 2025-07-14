//
//  DraggableBottomSheet.swift
//  DesignKit
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//
import SwiftUI

public struct DraggableBottomSheet<SmallContent: View, LargeContent: View>: View {
  @Binding var isPresented: Bool
  @State private var selectedDetent: PresentationDetent
  @State private var isAnimating: Bool = false
  
  let smallDetent: PresentationDetent
  let largeDetent: PresentationDetent
  let smallContent: () -> SmallContent
  let largeContent: () -> LargeContent
  
  private var isExpanded: Bool { selectedDetent == largeDetent }
  
  public init(
    isPresented: Binding<Bool>,
    smallHeight: CGFloat = 350,
    largeHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) {
    self._isPresented = isPresented
    self.smallDetent = .height(smallHeight)
    self.largeDetent = largeHeight != nil ? .height(largeHeight!) : .fraction(0.99)
    self._selectedDetent = State(initialValue: .height(smallHeight))
    self.smallContent = smallContent
    self.largeContent = largeContent
  }
  
  public var body: some View {
    EmptyView()
      .sheet(isPresented: $isPresented) {
        ZStack {
          Color.white.ignoresSafeArea()
          
          if isExpanded {
            largeContent()
              .transition(.opacity.combined(with: .scale(scale: 0.98)))
          } else {
            smallContent()
              .transition(.opacity.combined(with: .scale(scale: 0.98)))
          }
        }
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
        .presentationDetents([smallDetent, largeDetent], selection: $selectedDetent)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(16)
        .presentationBackgroundInteraction(.enabled(upThrough: smallDetent))
        .interactiveDismissDisabled(true)
        .presentationContentInteraction(.resizes)
        .onChange(of: selectedDetent) { _, _ in
          withAnimation { isAnimating = true }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { isAnimating = false }
        }
      }
  }
  
}
