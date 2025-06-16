//
//  LocationFeature.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import HomeDomainInterface

@Reducer
public struct LocationFeature {
  public init() {}
  
  public struct State: Equatable {
    var userLocation: MapPoint? = nil
    var point: MapPoint? = nil
    var isInitialMapLoad: Bool = true
  }
  
  public enum Action: Equatable {
    case fetchUserLocation
    case moveUserLocation
    case storeUserLocation(MapPoint)
    case moveLocation(MapPoint)
    case changeInitialMapLoad(Bool)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestMapBounds(Bool)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchUserLocation:
        return .run { send in
          await LocationService.shared.requestUserLocation()
        }
      case .moveUserLocation:
        return moveUserLocation(isIntialLoad: state.isInitialMapLoad)
        
      case let .storeUserLocation(location):
        state.userLocation = location
        return .none
        
      case let .moveLocation(point):
        state.point = point
        return .none
      case let .changeInitialMapLoad(isInitial):
        state.isInitialMapLoad = isInitial
        return .none
        
      default: return .none
      }
    }
  }
  
}

extension LocationFeature {
  
  private func moveUserLocation(isIntialLoad: Bool) -> Effect<Action> {
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        let userLocation = MapPoint(latitude: location.0, longitude: location.1)
        await send(.storeUserLocation(userLocation))
        await send(.moveLocation(userLocation))
        if isIntialLoad {
          await send(.delegate(.requestMapBounds(true)))
          await send(.changeInitialMapLoad(false))
        }
      } else if isIntialLoad {
        await send(.delegate(.requestMapBounds(true)))
        await send(.changeInitialMapLoad(false))
      }
    }
  }
}
