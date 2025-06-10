//
//  NavigationBarDemo.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

struct NavigationBarDemo: View {
  
  var body: some View {
    List {
      Section("뒤로가기 + 타이틀 + 닫기") {
        NavigationBar(
          backContent: {
            TouchArea(image: .cancel)
          },
          title: "text",
          closeContent: {
            TouchArea(image: .delete)
          }
        )
      }
      
      Section("뒤로가기 + 타이틀") {
        NavigationBar(
          backContent: {
            TouchArea(image: .cancel) {
              print("뒤로가기 버튼")
            }
          },
          title: "text"
        )
      }
      
      Section("타이틀 + 닫기") {
        NavigationBar(
          title: "text",
          closeContent: {
            TouchArea(image: .delete) {
              print("닫기 버튼")
            }
          }
        )
      }
      
      Section("뒤로가기 + 닫기") {
        NavigationBar(
          backContent: {
            TouchArea(image: .cancel)
          },
          title: nil,
          closeContent: {
            TouchArea(image: .delete) {
              print("닫기 버튼")
            }
          }
        )
      }
    }
  }
}

