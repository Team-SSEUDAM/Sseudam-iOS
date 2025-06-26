//
//  SelectPhotoFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import AVFoundation
import SwiftUI
import ComposableArchitecture

import Utility

@Reducer
public struct SelectPhotoFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public var isEnabled: Bool = false
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case centerButtonTapped
    
    public enum Delegate: Equatable {
      case centerButtonTapped
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .centerButtonTapped:
        return .send(.delegate(.centerButtonTapped))
      default: return .none
      }
    }
  }
}
