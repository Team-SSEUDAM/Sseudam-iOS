//
//  NotificationRootView.swift
//  Sseudam
//
//  Created by Jiyeon on 10/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct NotificationRootView: View {
  
  @Bindable var store: StoreOf<NotificationRootFeature>
  
  init(store: StoreOf<NotificationRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

//#Preview {
//  NotificationRootView()
//}
 
