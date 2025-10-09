//
//  NotificationRootView.swift
//  Sseudam
//
//  Created by Jiyeon on 10/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import NotificationFeature

struct NotificationRootView: View {
  
  @Bindable var store: StoreOf<NotificationRootFeature>
  
  init(store: StoreOf<NotificationRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    NotificationView(store: store.scope(state: \.notifications, action: \.notification))
  }
}

//#Preview {
//  NotificationRootView()
//}
 
