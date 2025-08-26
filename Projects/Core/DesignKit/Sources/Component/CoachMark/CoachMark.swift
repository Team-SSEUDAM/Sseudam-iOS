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
}

public struct CoachMark: View {
  
  @State private var isVisible: Bool = true
  
  private var isSpring: Bool = false
  private var position: CoachMarkPosition = .bottom
  private var offset: CGFloat = 0.0
  private var text: String
  private var action: (() -> Void)? = nil
  
  public init(
    text: String,
    offset: CGFloat = 0.0,
    action: (() -> Void)? = nil
  ) {
    self.text = text
    self.offset = offset
    self.action = action
  }
  
  public var body: some View {
    if !isVisible { EmptyView() }
    else {
      switch position {
      case .top:
        VStack(spacing: .Number0) {
          TailingView.frame(width: .Number36, height: .Number10)
            .padding(.leading, offset)
          ContentView
        }
        .onTapGesture {
          isVisible = false
          action?()
        }
        .onDisappear {
          action?()
        }
      case .bottom:
        VStack(spacing: .Number0) {
          ContentView
          TailingView.frame(width: .Number36, height: .Number10)
            .padding(.leading, offset)
        }
        .onTapGesture {
          isVisible = false
          action?()
        }
        .onDisappear {
          action?()
        }
      }
    }
  }
  
  public var ContentView: some View {
    Group {
      Text(text)
        .multilineTextAlignment(.center)
        .font(FontSet.Body.body3)
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
      path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.addCurve(
        to: CGPoint(x: rect.midX - 4.8, y: rect.minY + 5.625),
        control1: CGPoint(x: rect.minX + 9, y: rect.maxY),
        control2: CGPoint(x: rect.minX + 9, y: rect.maxY + 1.25)
      )
      path.addQuadCurve(
        to: CGPoint(x: rect.midX + 4.8, y: rect.minY + 5.625),
        control: CGPoint(x: rect.midX, y: rect.minY - 3.75)
      )
      path.addCurve(
        to: CGPoint(x: rect.maxX, y: rect.maxY),
        control1: CGPoint(x: rect.maxX - 9, y: rect.maxY + 1.25),
        control2: CGPoint(x: rect.maxX - 9, y: rect.maxY)
      )
      path.closeSubpath()
      
    case .bottom:
      path.move(to: CGPoint(x: rect.minX, y: rect.minY))
      path.addCurve(
        to: CGPoint(x: rect.midX - 4.8, y: rect.maxY - 5.625),
        control1: CGPoint(x: rect.minX + 9, y: rect.minY),
        control2: CGPoint(x: rect.minX + 9, y: rect.minY - 1.25)
      )
      path.addQuadCurve(
        to: CGPoint(x: rect.midX + 4.8, y: rect.maxY - 5.625),
        control: CGPoint(x: rect.midX, y: rect.maxY + 3.75)
      )
      path.addCurve(
        to: CGPoint(x: rect.maxX, y: rect.minY),
        control1: CGPoint(x: rect.maxX - 9, y: rect.minY - 1.25),
        control2: CGPoint(x: rect.maxX - 9, y: rect.minY)
      )
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
