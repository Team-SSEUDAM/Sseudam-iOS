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
  
  var body: some View {
    List {
      Section("Badge") {
        Badge(
          text: $badgeCount,
          state: .constant(.primary),
          icon: .addSpot
        )
        
        Badge(
          text: $badgeCount,
          state: .constant(.error)
        )
        
        Badge(
          text: $badgeCount,
          state: .constant(.accent)
        )
      }
    }
  }
}


#Preview {
  BadgeDemo()
}
