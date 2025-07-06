//
//  HomeRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature
import TrashDetailFeature
import DesignKit

@Reducer
struct HomeRootFeature {
  
  @ObservableState
  struct State: Equatable {
    var home: HomeFeature.State = HomeFeature.State()
    var trashDetail: TrashDetailFeature.State? = nil
    var isPresentDetail: Bool = false
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case home(HomeFeature.Action)
    case trashDetail(TrashDetailFeature.Action)
    
    case closeAlertAction(AlertType)
    case acceptAlertAction(AlertType)
    
    case delegate(Delegate)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case presentAlert(AlertType)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }
    Reduce { state, action in
      switch action {

        // MARK: - Alert
        
      case .closeAlertAction:
        return .none
        
      case let .acceptAlertAction(type):
        switch type {
        case .locationPermission:
          return .send(.home(.moveToSetting))
        default: return .none
        }
        
        // MARK: - Receive HomeFeature Delegate Action
        
      case let .home(.delegate(action)):
        switch action {
        case let .presentDetailView(isPresent, id):
          state.trashDetail = isPresent ? .init() : nil
          state.isPresentDetail = isPresent
          if isPresent {
            return .send(.trashDetail(.showDetail(id: id)))
          }
          return .none
          
        case let .presentAlert(alert):
          return .send(.delegate(.presentAlert(alert)))

          case let .needToHiddenTabBar(isHidden):
            return .send(.delegate(.hiddenTabBar(isHidden)))
        }
        
      default: return .none
      }
    }
    .ifLet(\.trashDetail, action: \.trashDetail) {
      TrashDetailFeature()
    }
  }
}
