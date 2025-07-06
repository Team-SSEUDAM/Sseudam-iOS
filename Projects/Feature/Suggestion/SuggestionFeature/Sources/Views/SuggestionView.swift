//
//  SuggestionView.swift
//
//  Suggestion
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct SuggestionView: View {
  @Bindable var store: StoreOf<SuggestionFeature>

  public init(store: StoreOf<SuggestionFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


