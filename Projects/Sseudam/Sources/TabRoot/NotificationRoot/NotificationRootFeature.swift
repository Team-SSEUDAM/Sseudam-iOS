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
import TrashSpotDomainInterface
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
    case showThrowTrash(data: TrashSpotDetail)
    case moveAcceptList
    case showRefuseAlert(reason: String)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    case trashThrowConfirm(TrashThrowConfirmFeature)
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
        
      case let .modal(.presented(.trashThrowConfirm(action))):
        switch action {
        case let .delegate(.showTrashDetail(data)):
          print("dismiss")
          state.modal = nil
          return .send(.delegate(.showThrowTrash(data: data)))
        default:
          return .none
        }
        
      case let .notification(.delegate(action)):
        switch action {
        case let .requestLogin(isPresent):
          return .send(.delegate(.requestLogin(isPresent, .notification)))
          
        case let .showThrowTrash(data):
          state.modal = .trashThrowConfirm(
            TrashThrowConfirmFeature.State(trashDetail: data)
          )
          return .none 
          
        case .moveAcceptList:
          return .send(.delegate(.moveAcceptList))
          
        case let .showRefuseAlert(reason):
          return .send(.delegate(.showRefuseAlert(reason: reason)))
          
        }
      default: return .none
      }
    }
    .ifLet(\.$modal, action: \.modal)
  }
  
  
  
}
