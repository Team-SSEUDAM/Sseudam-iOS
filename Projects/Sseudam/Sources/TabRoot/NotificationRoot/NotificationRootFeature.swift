//
//  NotificationRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 10/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility

@Reducer
struct NotificationRootFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var modal: ModalDestination.State?
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case modal(PresentationAction<ModalDestination.Action>)
  }
  
  enum Delegate: Equatable {
    
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { stata, action in
      switch action {
      default: return .none
      }
    }
  }
  
  
  
}
