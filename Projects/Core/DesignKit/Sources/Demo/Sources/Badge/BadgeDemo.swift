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
          state: .constant(.primary)
        ) {
          Icon(image: .add, size: .Number16)
        }
        
        Badge(
          text: $badgeCount,
          state: .constant(.error)
        ) {
          Icon(image: .add, size: .Number16)
        }
        
        Badge(
          text: $badgeCount,
          state: .constant(.accent)
        ) {
          Icon(image: .add, size: .Number16)
            .foregroundColor(ColorSet.Icon.Inverse)
        }
      }
    }
  }
}


#Preview {
  BadgeDemo()
}
