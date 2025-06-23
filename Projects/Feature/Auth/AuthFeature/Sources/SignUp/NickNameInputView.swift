//
//  NickNameInputView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct NickNameInputView: View {
  
  @Bindable var store: StoreOf<NickNameInputFeature>
  
  public init(store: StoreOf<NickNameInputFeature>) {
    self.store = store
  }
  
  public var body: some View {
    EmptyView()
  }
}
