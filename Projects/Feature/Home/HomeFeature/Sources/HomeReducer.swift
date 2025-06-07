//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import HomeFeatureInterface
import ComposableArchitecture

extension HomeReducer {
  public static let HomeReducer = Reduce<State, Action> { state, action in
    switch action {
    default:
      return .none
    }
  }
}
