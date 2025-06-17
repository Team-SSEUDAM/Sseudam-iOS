//
//  ChipButtonDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct CategoryButtonDemo: View {
  @State private var categoryButtonState: CategoryButtonState = .normal
  var body: some View {
    List {
      Section("일반 칩 버튼") {
        CategoryButton(
          text: "칩버튼",
          state: $categoryButtonState
        ) {
          print("칩버튼 클릭")
        }
        CategoryButton(
          text: "칩버튼",
          state: .constant(.selected)
        ) {
          print("칩버튼 클릭")
        }
      }
      
      Section("아이콘 칩 버튼") {
        CategoryButton(
          text: "아이콘칩",
          state: .constant(.normal),
          icon: .addSpot
        ) {
          print("아이콘칩 클릭")
        }
        CategoryButton(
          text: "아이콘칩",
          state: .constant(.selected),
          icon: .addSpot
        ) {
          print("아이콘칩 클릭")
        }
      }
    }
  }
}

#Preview {
  CategoryButtonDemo()
}
