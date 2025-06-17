//
//  TrashDetailView.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture

public struct TrashDetailView: View {
  @Bindable var store: StoreOf<TrashDetailFeature>

  public init(store: StoreOf<TrashDetailFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


