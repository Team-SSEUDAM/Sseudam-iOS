//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct HomeFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var location: LocationState = .init()
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationAction)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      default: return .none
      }
    }
  }
}


