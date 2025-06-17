//
//  TouchArea.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct TouchArea: View {
  
  private let image: ImageSet
  private let size: CGFloat
  private let action: @Sendable () async -> Void
  
  public init(
    image: ImageSet,
    size: CGFloat = .Number32,
    _ action: @escaping @Sendable () async -> Void
  ) {
    self.image = image
    self.size = size
    self.action = action
  }
  
  public var body: some View {
    Button {
      Task { await action() }
    } label: {
      content
    }
  }
  
  @ViewBuilder private var content: some View {
    Rectangle()
      .fill(.clear)
      .overlay {
        Icon(
          image: image,
          size: size
        )
      }
      .frame(width: .Number48, height: .Number48, alignment: .center)
  }
}

#Preview {
  TouchArea(
    image: .addSpot,
    size: .Number24
  ) {
    print("TouchArea tapped")
  }
}
