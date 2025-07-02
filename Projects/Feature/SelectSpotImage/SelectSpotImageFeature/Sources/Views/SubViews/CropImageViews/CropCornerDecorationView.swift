//
//  CropCornerDecorationView.swift
//  SelectSpotImageFeature
//
//  Created by 조용인 on 7/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct CropCornerDecorationView: View {
  private let position: (x: CGFloat, y: CGFloat)
  private let correction: (x: CGFloat, y: CGFloat)
  
  public init(
    position: (x: CGFloat, y: CGFloat),
    correction: (x: CGFloat, y: CGFloat)
  ) {
    self.position = position
    self.correction = correction
  }
  
  public var body: some View {
    ZStack {
      /// 가로
      Rectangle()
        .fill(ColorSet.Gray._0)
        .frame(width: .Number26, height: .Number3)
        .offset(x: position.x < .Number0 ? .Number12 : -.Number12, y: .Number0)
      /// 세로
      Rectangle()
        .fill(ColorSet.Gray._0)
        .frame(width: .Number3, height: .Number26)
        .offset(x: .Number0, y: position.y < .Number0 ? .Number12 : -.Number12)
    }
    .offset(x: position.x + correction.x, y: position.y + correction.y)
  }
}

