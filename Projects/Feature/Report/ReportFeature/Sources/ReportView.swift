//
//  ReportView.swift
//
//  Report
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

public struct ReportView: View {
  @Bindable var store: StoreOf<ReportFeature>

  public init(store: StoreOf<ReportFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


