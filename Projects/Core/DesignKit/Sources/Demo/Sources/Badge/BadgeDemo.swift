//
//  BadgeDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct BadgeDemo: View {
  
  @State private var badgeCount: String = "test"
  @State private var badgeState: BadgeState = .primary
  
  var body: some View {
    List {
      Button("Toggle") {
        badgeCount += "#"
        badgeState = .accent
      }
      
      Section("Badge") {
        Badge(
          text: $badgeCount,
          state: badgeState,
          icon: .addSpot
        )
        
        Badge(
          text: $badgeCount,
          state: badgeState
        )
        
        Badge(
          text: $badgeCount,
          state: badgeState
        )
      }
    }
  }
}


#Preview {
  BadgeDemo()
}
