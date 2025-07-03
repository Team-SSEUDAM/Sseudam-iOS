//
//  CropOverlayView.swift
//  SelectSpotImageFeature
//
//  Created by 조용인 on 7/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct CropOverlayView: View {
  @Binding var gridSize: CGFloat
  @Binding var gridPosition: CGPoint
  private let proxy: GeometryProxy
  private let imageRatio: CGSize
  
  public init(
    gridSize: Binding<CGFloat>,
    gridPosition: Binding<CGPoint>,
    proxy: GeometryProxy,
    imageRatio: CGSize
  ) {
    self._gridSize = gridSize
    self._gridPosition = gridPosition
    self.proxy = proxy
    self.imageRatio = imageRatio
  }
  
  public var body: some View {
    ZStack {
      /// 크롭 박스 주변을 어둡게 처리하는 오버레이
      Rectangle()
        .fill(ColorSet.Gray._1000.opacity(0.6))
        .mask(
          Rectangle()
            .fill(Color.black)
            .overlay(
              Rectangle()
                .frame(width: gridSize, height: gridSize)
                .position(gridPosition)
                .blendMode(.destinationOut)
            )
        )
        .allowsHitTesting(false)
      
      ZStack {
        /// 크롭 박스
        Rectangle()
          .stroke(ColorSet.Gray._0, lineWidth: .Number1)
          .contentShape(Rectangle())
          .frame(width: gridSize, height: gridSize)
        /// 코너 격자 장식
        ForEach(Corner.allCases, id: \.self) { corner in
          CropCornerDecorationView(
            position: corner.point(for: gridSize),
            correction: corner.correction
          )
        }
      }
      .frame(width: gridSize, height: gridSize)
      .position(gridPosition)
      .gesture(
        DragGesture()
          .onChanged { v in
            let imageHeight = imageRatio.height * gridSize
            let imageTop = (proxy.size.height - imageHeight) / 2
            let imageBottom = imageTop + imageHeight
            let halfGrid = gridSize / 2
            gridPosition.y = min(imageBottom - halfGrid, max(imageTop + halfGrid, v.location.y))
          }
      )
    }
  }
}

private enum Corner: CaseIterable {
  case topLeft, topRight, bottomRight, bottomLeft
  
  var sign: CGPoint {
    switch self {
    case .topLeft:     return CGPoint(x: -1, y: -1)
    case .topRight:    return CGPoint(x:  1, y: -1)
    case .bottomRight: return CGPoint(x:  1, y:  1)
    case .bottomLeft:  return CGPoint(x: -1, y:  1)
    }
  }
  
  func point(for size: CGFloat) -> (x: CGFloat, y: CGFloat) {
    (sign.x * size/2, sign.y * size/2)
  }
  
  var correction: (x: CGFloat, y: CGFloat) {
    switch self {
    case .topLeft: return (-1, -1)
    case .topRight: return (1, -1)
    case .bottomRight: return (1, 1)
    case .bottomLeft: return (-1,1)
    }
  }
}
