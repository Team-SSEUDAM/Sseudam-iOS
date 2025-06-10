//
//  IconButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct IconButtonDemo: View {
  
  var body: some View {
    HStack {
      IconButton(
        icon: {
          Icon(image: .addSpot)
        }
      ) {
        print("Add Spot tapped")
      }
    }
  }
}

#Preview {
  IconButtonDemo()
}
