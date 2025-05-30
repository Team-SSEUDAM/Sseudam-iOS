//
//  SampleView.swift
//
//  Sample
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct SampleView: View {
  @Bindable var store: StoreOf<SampleReducer>

  public init(store: StoreOf<SampleReducer>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


