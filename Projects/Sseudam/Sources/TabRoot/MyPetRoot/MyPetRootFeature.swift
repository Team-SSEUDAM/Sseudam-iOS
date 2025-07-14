//
//  MyPetRootFeature.swift
//  Sseudam
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import MyPetFeature

@Reducer
struct MyPetRootFeature {
  @ObservableState
  struct State {
    var myPet: MyPetFeature.State = MyPetFeature.State()
    init() {}
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case myPet(MyPetFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      default: return .none
      }
    }
  }
}
