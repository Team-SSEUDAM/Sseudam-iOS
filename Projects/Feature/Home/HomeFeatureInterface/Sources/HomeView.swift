//
//  HomeView.swift
//
//  Home
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
  @Bindable var store: StoreOf<HomeReducer>

  public init(store: StoreOf<HomeReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


