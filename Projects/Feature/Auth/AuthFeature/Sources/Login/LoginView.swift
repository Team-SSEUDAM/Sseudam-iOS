//
//  LoginView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct LoginView: View {
  @Bindable var store: StoreOf<LoginFeature>
  
  public init(store: StoreOf<LoginFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      NavigationBar(
        closeContent: {
          TouchArea(image: .close) {
            store.send(.closeButtonTapped)
          }
        }
      )
      Spacer()
      
    }
  }
}
