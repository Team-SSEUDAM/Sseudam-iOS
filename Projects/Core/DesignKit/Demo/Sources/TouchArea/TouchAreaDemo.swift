//
//  TouchAreaDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct TouchAreaDemo: View {
  
  var body: some View {
    HStack {
      TouchArea(
        image: .addSpot,
        size: .superLarge
      ) {
        print("Super Large")
      }
      .background {
        Color.gray.opacity(0.2)
      }
      
      TouchArea(
        image: .addSpot,
        size: .medium
      ) {
        print("Medium")
      }
      .background {
        Color.gray.opacity(0.2)
      }
      
      TouchArea(
        image: .addSpot,
        size: .small
      ) {
        print("Small")
      }
      .background {
        Color.gray.opacity(0.2)
      }
    }
  }
}
