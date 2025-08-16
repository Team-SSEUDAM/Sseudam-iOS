//
//  CoachMark.swift
//  DesignKit
//
//  Created by 조용인 on 8/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

// TODO: 나중에 코치마크 반영할 때, 다시 수정
public enum CoachMarkPosition : Sendable {
  case top
  case bottom
  case left
  case right
}

public struct CoachMark: View {
  
  private var isSpring: Bool = false
  private var position: CoachMarkPosition = .bottom
  private var text: String
  
  public init(
    text: String
  ) {
    self.text = text
  }
  
  public var body: some View {
    
    switch position {
    case .top:
      VStack(spacing: .Number0) {
        TailingView.frame(width: .Number30, height: .Number8)
        ContentView
      }
    case .bottom:
      VStack(spacing: .Number0) {
        ContentView
        TailingView.frame(width: .Number30, height: .Number8)
      }
    case .left:
      HStack(spacing: .Number0) {
        TailingView.frame(width: .Number30, height: .Number8)
        ContentView
      }
    case .right:
      HStack(spacing: .Number0) {
        ContentView
        TailingView.frame(width: .Number30, height: .Number8)
      }
    }
  }
  
  public var ContentView: some View {
    Group {
      Text(text)
        .font(FontSet.Caption.caption2)
        .foregroundColor(ColorSet.Text.Inverse)
        .padding(.horizontal, .Number10)
        .padding(.vertical, .Number6)
    }
    .background(ColorSet.Background.Inverse)
    .elevation()
    .clipCorners(.Number10, corners: .allCorners)
  }
  
  public var TailingView: some View {
    CoachMarkTail(position: position)
      .fill(ColorSet.Background.Inverse)
  }
}

public struct CoachMarkTail: Shape {
  let position: CoachMarkPosition
  
  public func path(in rect: CGRect) -> Path {
    var path = Path()
    
    switch position {
    case .top:
      // 위쪽 꼬리 (아래로 향하는 뭉툭한 V)
      path.move(to: CGPoint(x: rect.midX - 6, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.midX - 1, y: rect.minY + 2))
      path.addQuadCurve(
        to: CGPoint(x: rect.midX + 1, y: rect.minY + 2),
        control: CGPoint(x: rect.midX, y: rect.minY)
      )
      path.addLine(to: CGPoint(x: rect.midX + 6, y: rect.maxY))
      path.closeSubpath()
      
    case .bottom:
      // 아래쪽 꼬리 (위로 향하는 뭉툭한 V)
      path.move(to: CGPoint(x: rect.midX - 6, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.midX - 1, y: rect.maxY - 2))
      path.addQuadCurve(
        to: CGPoint(x: rect.midX + 1, y: rect.maxY - 2),
        control: CGPoint(x: rect.midX, y: rect.maxY)
      )
      path.addLine(to: CGPoint(x: rect.midX + 6, y: rect.minY))
      path.closeSubpath()
      
    case .left:
      // 왼쪽 꼬리 (오른쪽으로 향하는 뭉툭한 V)
      path.move(to: CGPoint(x: rect.maxX, y: rect.midY - 6))
      path.addLine(to: CGPoint(x: rect.minX + 2, y: rect.midY - 1))
      path.addQuadCurve(
        to: CGPoint(x: rect.minX + 2, y: rect.midY + 1),
        control: CGPoint(x: rect.minX, y: rect.midY)
      )
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + 6))
      path.closeSubpath()
      
    case .right:
      // 오른쪽 꼬리 (왼쪽으로 향하는 뭉툭한 V)
      path.move(to: CGPoint(x: rect.minX, y: rect.midY - 6))
      path.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.midY - 1))
      path.addQuadCurve(
        to: CGPoint(x: rect.maxX - 2, y: rect.midY + 1),
        control: CGPoint(x: rect.maxX, y: rect.midY)
      )
      path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + 6))
      path.closeSubpath()
    }
    
    return path
  }
}

extension CoachMark {
  public func position(_ position: CoachMarkPosition) -> CoachMark {
    var copy = self
    copy.position = position
    return copy
  }
  
  public func spring(_ isSpring: Bool = true) -> CoachMark {
    var copy = self
    copy.isSpring = isSpring
    return copy
  }
}
