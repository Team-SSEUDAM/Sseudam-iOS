//
//  MyPetRootView.swift
//  Sseudam
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MyPetFeature
import DesignKit

struct MyPetRootView: View {
  
  @Bindable var store: StoreOf<MyPetRootFeature>
  
  init(store: StoreOf<MyPetRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    MyPetView(store: store.scope(state: \.myPet, action: \.myPet))
      .draggableBottomSheet(
        isPresented: .constant(true),
        smallHeight: 68,
        smallContent: { },
        largeContent: { }
      )
  }
}
