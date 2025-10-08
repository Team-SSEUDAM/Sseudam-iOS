//
//  NotificationRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 10/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

import NotificationFeature
import AuthFeature
import Utility

@Reducer
struct NotificationRootFeature {
  @ObservableState
  struct State: Equatable {
    var notification: NotificationFeature.State = .init()
    @Presents var modal: ModalDestination.State?
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case notification(NotificationFeature.Action)
    
    case checkLoggedin
    case delegate(Delegate)
    case modal(PresentationAction<ModalDestination.Action>)
  }
  
  enum Delegate: Equatable {
    case requestLogin(Bool, AuthEntryPoint)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.notification, action: \.notification) {
      NotificationFeature()
    }
    Reduce { stata, action in
      switch action {
      case .checkLoggedin:
        return .send(.notification(.checkLoggedIn))
        
      case let .notification(.delegate(action)):
        switch action {
        case let .requestLogin(isPresent):
          return .send(.delegate(.requestLogin(isPresent, .notification)))
        }
      default: return .none
      }
    }
  }
  
  
  
}
