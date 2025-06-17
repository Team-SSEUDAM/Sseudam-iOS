//
//  TouchAreaDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct TouchAreaDemo: View {
  
  var body: some View {
    HStack {
      TouchArea(
        image: .addSpot,
        size: .Number32
      ) {
        print("Super Large")
      }
      .background {
        Color.gray.opacity(0.2)
      }
      
      TouchArea(
        image: .addSpot,
        size: .Number18
      ) {
        print("Medium")
      }
      .background {
        Color.gray.opacity(0.2)
      }
      
      TouchArea(
        image: .addSpot,
        size: .Number16
      ) {
        print("Small")
      }
      .background {
        Color.gray.opacity(0.2)
      }
    }
  }
}
