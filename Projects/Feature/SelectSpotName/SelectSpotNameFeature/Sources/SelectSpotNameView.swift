//
//  SelectSpotNameView.swift
//
//  SelectSpotName
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SelectSpotNameView: View {
  @Bindable var store: StoreOf<SelectSpotNameFeature>

  public init(store: StoreOf<SelectSpotNameFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


