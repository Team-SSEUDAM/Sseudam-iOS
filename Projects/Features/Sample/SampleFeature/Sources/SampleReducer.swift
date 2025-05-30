//
//  SampleReducer.swift
//
//  Sample
//
//  Created by JiYeon
//

import SampleFeatureInterface
import ComposableArchitecture

extension SampleReducer {
  public static let SampleReducer = Reduce<State, Action> { state, action in
    switch action {
    default:
      return .none
    }
  }
}
