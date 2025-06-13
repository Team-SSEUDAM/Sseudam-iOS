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
  }
  
  public enum Action: Equatable {
    case fetchUserLocation
    case moveUserLocation
    case storeUsserLocation(MapPoint)
    case moveLocation(MapPoint)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchUserLocation:
        return .run { send in
          await LocationService.shared.requestUserLocation()
        }
      case .moveUserLocation:
        return .run { send in
          if let location = await LocationService.shared.userLocation {
            let userLocation = MapPoint(latitude: location.0, longitude: location.1)
            await send(.storeUsserLocation(userLocation))
            await send(.moveLocation(userLocation))
          }
        }
        
      case let .storeUsserLocation(location):
        state.userLocation = location
        return .none
      case let .moveLocation(point):
        state.point = point
        return .none
      }
    }
  }
  
}
