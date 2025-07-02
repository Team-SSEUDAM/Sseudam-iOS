//
//  SelectSpotImageView.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SelectSpotImageView: View {
  @Bindable var store: StoreOf<SelectSpotImageFeature>

  public init(store: StoreOf<SelectSpotImageFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


