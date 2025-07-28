//
//  ContentView.swift
//  DesignKit
//
//  Created by 조용인 on 7/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    HeaderPageScrollView(
      displaysSymbols: false,
      header: {
        RoundedRectangle(cornerRadius: 30)
          .fill(.blue.gradient)
          .frame(height: 350)
          .padding(15)
      }, pageLabels: {
        PageLabel(title: "Posts", symbolImage: "square.grid.3x3.fill")
        PageLabel(title: "Reels", symbolImage: "photo.stack.fill")
        PageLabel(title: "Tagged", symbolImage: "person.crop.rectangle")
      }, pages: [
        DummyView(.red, count: 50),
        DummyView(.yellow, count: 10),
        DummyView(.indigo, count: 5),
      ],
      onRefresh: {
        print("Refresh triggered")
      }
    )
  }
  
  @ViewBuilder
  private func DummyView(_ color: Color, count: Int) -> some View {
    LazyVStack(spacing: 10) {
      ForEach(0..<count, id: \.self) { index in
        RoundedRectangle(cornerRadius: 10)
          .fill(color.gradient)
          .frame(height: 45)
          .padding(.horizontal, 15)
      }
    }
    .padding(.vertical, 10)
  }
}

#Preview {
    ContentView()
}
