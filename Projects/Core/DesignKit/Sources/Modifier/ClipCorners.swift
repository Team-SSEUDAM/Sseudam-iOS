//
//  ClipCorners.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

/// 원하는 방향의 모서리만 둥글게 만들 수 있도록 도와주는 Extension
///
/// UIKit의 `UIRectCorner`를 사용하여,
/// 좌상단, 우상단, 좌하단, 우하단 중 원하는 방향의 corner만 radius를 적용할 수 있습니다.
///
/// 사용 예시:
/// ```swift
/// MyView()
///   .clipCorners(16, corners: [.topLeft, .topRight])
/// ```
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
  /// 지정한 방향의 모서리만 둥글게 처리합니다.
  ///
  /// - Parameters:
  ///   - radius: 적용할 corner radius 값
  ///   - corners: 둥글게 만들고 싶은 모서리 방향 (예: [.topLeft, .bottomRight])
  /// - Returns: 일부 모서리에만 radius가 적용된 View
  public func clipCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    self.modifier(CornerRadiusModifier(corners: corners, radius: radius))
  }
}
