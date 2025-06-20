//
//  ClipCorners.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

fileprivate struct CustomRoundedRectangle: Shape {
  var corners: UIRectCorner
  var cornerRadius: CGFloat
  
  init(corners: UIRectCorner, cornerRadius: CGFloat = 16) {
    self.corners = corners
    self.cornerRadius = cornerRadius
  }
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
    )
    return Path(path.cgPath)
  }
}

fileprivate struct CornerRadiusModifier: ViewModifier {
  let corners: UIRectCorner
  let radius: CGFloat
  
  func body(content: Content) -> some View {
    content
      .clipShape(CustomRoundedRectangle(corners: corners, cornerRadius: radius))
  }
}

extension View {
  /// 원하는 방향에 corner radius를 줄 수 있는 modifier
  ///
  /// - 사용 예시
  /// ```swift
  /// content
  ///   .clipCorners(.Number16, corners: [.topLeft, .topRight])
  public func clipCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    self.modifier(CornerRadiusModifier(corners: corners, radius: radius))
  }
}
