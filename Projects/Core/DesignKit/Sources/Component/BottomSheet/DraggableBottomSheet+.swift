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
    isIgnoreTabBar: Binding<Bool>,
    smallHeight: CGFloat = 350,
    largeHeight: CGFloat? = nil,
    @ViewBuilder smallContent: @escaping () -> SmallContent,
    @ViewBuilder largeContent: @escaping () -> LargeContent
  ) -> some View {
    self.modifier(
      DraggableBottomSheet(
        isPresented: isPresented,
        isIgnoreTabbar: isIgnoreTabBar,
        smallHeight: smallHeight,
        largeHeight: largeHeight,
        smallContent: smallContent,
        largeContent: largeContent
      )
    )
  }
  
  @ViewBuilder
  func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
    self
      .background(SheetRootViewFinder(mask: mask, height: height))
  }
}

fileprivate extension UIView {
  var viewBeforeWindow: UIView? {
    if let superview, superview is UIWindow {
      return self
    }
    return superview?.viewBeforeWindow
  }
  
  var allSubViews: [UIView] {
    return subviews.flatMap { [$0] + $0.subviews }
  }
}

fileprivate struct SheetRootViewFinder: UIViewRepresentable {
  var mask: Bool = true
  var height: CGFloat
  
  func makeUIView(context: Context) -> UIView {
    return .init()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      if let rootview = uiView.viewBeforeWindow, let window = rootview.window {
        let safeArea = window.safeAreaInsets
        rootview.frame = .init(
          origin: .zero,
          size: .init(
            width: rootview.frame.width,
            height: rootview.frame.height - (mask ? height + safeArea.bottom : 0)
          )
        )
        
        for view in rootview.subviews {
          view.layer.shadowColor = UIColor.clear.cgColor
          
          if view.layer.animationKeys() != nil {
            print("Animation keys found in view: \(view)")
            if let cornerRadiusView = view.allSubViews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
              cornerRadiusView.layer.maskedCorners = []
            }
          }
        }
      }
    }
      
  }
}
