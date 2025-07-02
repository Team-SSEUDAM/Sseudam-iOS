//
//  SelectSpotLocationView.swift
//
//  SelectSpotLocation
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SelectSpotLocationView: View {
  @Bindable var store: StoreOf<SelectSpotLocationFeature>

  public init(store: StoreOf<SelectSpotLocationFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


