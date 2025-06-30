//
//  SignUpCompleteFeature.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import UserDefaults

@Reducer
public struct SignUpCompleteFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var nickname: String?
    public init() {
      self.nickname = UserDefaultsKeys.username
    }
  }
  
  public enum Action: Equatable {
    case startButtonTapped
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .startButtonTapped:
        return .send(.delegate(.dismiss))
      default: return .none
      }
    }
  }
  
  
}
