//
//  VisitedFeature.swift
//  TrashDetailFeature
//
//  Created by Jiyeon on 7/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import DesignKit

@Reducer
public struct VisitedFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var isVisitedButtonEnable: PrimaryButtonState = .disabled
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case fetchUserLocation
    case userLocation
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchUserLocation:
        return .run { send in
          await LocationService.shared.requestUserLocation(mode: .continuous)
        }
      case .userLocation:
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            print(location)
          }
        }
        
      default: return .none
      }
    }
  }
  
}
