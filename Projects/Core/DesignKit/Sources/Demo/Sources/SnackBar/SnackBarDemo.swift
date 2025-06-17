//
//  SnackBarDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

struct SnackBarDemo: View {
  @State var message: String? = ""
  @State var title: Int = 0
  var body: some View {
    ZStack {
      VStack {
        Button("\(title)") {
          message = "토스트 메세지!"
        }
      }
      Spacer()
      SnackBar(
        message: $message,
        buttonLabel: "label"
      ) {
        title += 1
      }
    }
  }
}

#Preview {
  SnackBarDemo()
}
