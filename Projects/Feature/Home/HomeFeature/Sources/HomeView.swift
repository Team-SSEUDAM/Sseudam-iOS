//
//  HomeView.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
  @Bindable var store: StoreOf<HomeReducer>

  public init(store: StoreOf<HomeReducer>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      Text("hello")
    }
  }
}


