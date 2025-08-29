//
//  LevelUpView.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

public struct LevelUpView: View {
  @Bindable var store: StoreOf<LevelUpFeature>

  public init(store: StoreOf<LevelUpFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


