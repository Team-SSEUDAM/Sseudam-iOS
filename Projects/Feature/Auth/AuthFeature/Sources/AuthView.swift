//
//  AuthView.swift
//
//  Auth
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct AuthView: View {
  @Bindable var store: StoreOf<AuthFeature>

  public init(store: StoreOf<AuthFeature>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Text("dddd")
    }
  }
}


