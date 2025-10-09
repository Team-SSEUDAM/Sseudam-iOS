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
    var notifications: NotificationFeature.State = .init()
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
    case showThrowTrash(id: Int)
    case moveAcceptList
    case showRefuseAlert
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.notifications, action: \.notification) {
      NotificationFeature()
    }
    Reduce { state, action in
      switch action {
      case .checkLoggedin:
        return .send(.notification(.checkLoggedIn))
        
      case let .notification(.delegate(action)):
        switch action {
        case let .requestLogin(isPresent):
          return .send(.delegate(.requestLogin(isPresent, .notification)))
          
        case let .showThrowTrash(id):
          return .send(.delegate(.showThrowTrash(id: id)))
          
        case .moveAcceptList:
          return .send(.delegate(.moveAcceptList))
          
        case .showRefuseAlert:
          return .send(.delegate(.showRefuseAlert))
          
        }
      default: return .none
      }
    }
  }
  
  
  
}
