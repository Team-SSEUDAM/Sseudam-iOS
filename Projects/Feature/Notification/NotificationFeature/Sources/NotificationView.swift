//
//  NotificationView.swift
//
//  Notification
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

public struct NotificationView: View {
  @Bindable var store: StoreOf<NotificationFeature>

  public init(store: StoreOf<NotificationFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


