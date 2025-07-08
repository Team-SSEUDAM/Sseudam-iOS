//
//  MyPetView.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct MyPetView: View {
  @Bindable var store: StoreOf<MyPetFeature>

  public init(store: StoreOf<MyPetFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


