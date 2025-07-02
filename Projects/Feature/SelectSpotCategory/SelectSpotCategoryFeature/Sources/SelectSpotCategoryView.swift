//
//  SelectSpotCategoryView.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SelectSpotCategoryView: View {
  @Bindable var store: StoreOf<SelectSpotCategoryFeature>

  public init(store: StoreOf<SelectSpotCategoryFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


