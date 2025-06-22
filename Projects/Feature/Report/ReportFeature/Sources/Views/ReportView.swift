//
//  ReportView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct ReportView: View {
  @Bindable var store: StoreOf<ReportFeature>
  
  public init(store: StoreOf<ReportFeature>) {
    self.store = store
  }
  
  public var body: some View {
    
    VStack {
      MoveLocationView(store: store.scope(state: \.moveLocation, action: \.moveLocation))
    }
  }
}

#Preview {
  ReportView(
    store: Store(
      initialState: ReportFeature.State()
    ) {
      ReportFeature()
    }
  )
}


