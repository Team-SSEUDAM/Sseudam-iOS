//
//  CropOverlayView.swift
//  ReportFeature
//
//  Created by 조용인 on 7/1/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit


public struct CropOverlayView: View {
  private let cropSize: CGFloat
  
  public init(cropSize: CGFloat) {
    self.cropSize = cropSize
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
                .frame(width: cropSize, height: cropSize)
                .blendMode(.destinationOut)
            )
        )
        .allowsHitTesting(false)
      
      /// 크롭 프레임
      Rectangle()
        .stroke(ColorSet.Gray._0, lineWidth: .Number1)
        .frame(width: cropSize, height: cropSize)
        .allowsHitTesting(false)
      
      /// 코너 격자
      ForEach(0..<4) { index in
        let position = cornerPosition(for: index, size: cropSize)
        let correction = cornerCorrection(for: index)
        CornerDecoration(position: position, correction: correction)
      }
    }
  }
  
  private func cornerPosition(for index: Int, size: CGFloat) -> (x: CGFloat, y: CGFloat) {
    switch index {
    case 0: return (-size/2, -size/2) // 좌상단
    case 1: return (size/2, -size/2)  // 우상단
    case 2: return (size/2, size/2)   // 우하단
    case 3: return (-size/2, size/2)  // 좌하단
    default: return (0, 0)
    }
  }
  
  private func cornerCorrection(for index: Int) -> (x: CGFloat, y: CGFloat) {
    switch index {
    case 0: return (-1, -1) // 좌상단
    case 1: return (1, -1)  // 우상단
    case 2: return (1, 1)   // 우하단
    case 3: return (-1,1)  // 좌하단
    default: return (0, 0)
    }
  }
}

