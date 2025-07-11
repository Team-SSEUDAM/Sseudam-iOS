//
//  MyPageView.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct MyPageView: View {
  @Bindable var store: StoreOf<MyPageFeature>

  public init(store: StoreOf<MyPageFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


