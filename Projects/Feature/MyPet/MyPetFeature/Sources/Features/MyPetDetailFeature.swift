//
//  MyPetDetailFeature.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/14/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import UserDefaults
import AuthFeature

@Reducer
public struct MyPetDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case backButtonTapped
    case pop
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .send(.pop)
      default: return .none
      }
    }
  }
}
