//
//  AlertDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct AlertDemo: View {
  var body: some View {
    Alert(
      type: .sample,
      closeAction: { print("닫기 버튼") },
      acceptAction: { print("확인 버튼") }
    )
  }
}

