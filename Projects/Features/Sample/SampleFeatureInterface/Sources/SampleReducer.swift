//
//  SampleReducer.swift
//
//  Sample
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct SampleReducer {
  private let reducer: Reduce<State, Action>
  
  public init(reducer: Reduce<State, Action>) {
    self.reducer = reducer
  }
  
  @ObservableState
  public struct State: BindableAction, Equatable {
    
    public init() {}
  }

  public enum Action: Equatable {
    case binding(BindingAction<State>)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    reducer
  }
}
