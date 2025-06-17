//
//  ChipButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct CategoryButtonDemo: View {
  var body: some View {
    List {
      Section("일반 칩 버튼") {
        CategoryButton(
          text: "칩버튼",
          state: .constant(.normal)
        )
        CategoryButton(
          text: "칩버튼",
          state: .constant(.selected)
        )
      }
      
      Section("아이콘 칩 버튼") {
        CategoryButton(
          text: "아이콘칩",
          state: .constant(.normal),
          icon: .addSpot
        )
        CategoryButton(
          text: "아이콘칩",
          state: .constant(.selected),
          icon: .addSpot
        )
      }
    }
  }
}

#Preview {
  CategoryButtonDemo()
}
