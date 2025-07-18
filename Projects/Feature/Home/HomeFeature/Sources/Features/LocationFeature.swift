//
//  LocationFeature.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import TrashSpotDomainInterface

@Reducer
public struct LocationFeature {
  public init() {}
  
  public struct State: Equatable {
    /// 유저의 현재 위치
    var userLocation: Coordinates? = nil
    /// 이동하고자 하는 위치
    var point: Coordinates? = nil
    /// 초기 이동 여부
    var isInitialMapLoad: Bool = true
    
    var lastCameraPosition: Coordinates? = nil
    
    var isCurrentButtonTap: Bool = false
  }
  
  public enum Action: Equatable {
    case fetchCurrentLocation(Bool)
    /// 유저의 현위치 가져오기
    case fetchUserLocation
    /// 유저 위치로 지도 이동
    case moveUserLocation
    /// 유저 위치 저장
    case storeUserLocation(Coordinates)
    /// 특정 위치로 이동하기
    case moveLocation(Coordinates)
    /// 첫 로드 여부 저장
    case changeInitialMapLoad(Bool)
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestMapBounds(Bool)
    case denyLocationPermission
  }
  
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
      case let .fetchCurrentLocation(isRequest):
        state.isCurrentButtonTap = isRequest
        if isRequest {
          return .send(.fetchUserLocation)
        } else {
          return .none
        }
        
      case .fetchUserLocation:
        return .run { send in
          await LocationService.shared.requestUserLocation()
        }
      case .moveUserLocation:
        return moveUserLocation(
          isCurrentButtonTapped: state.isCurrentButtonTap ,
          isIntialLoad: state.isInitialMapLoad
        )
        
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
  
  private func moveUserLocation(isCurrentButtonTapped: Bool, isIntialLoad: Bool) -> Effect<Action> {
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        let userLocation = Coordinates(latitude: location.0, longitude: location.1)
        await send(.storeUserLocation(userLocation))
        await send(.moveLocation(userLocation))
        if isIntialLoad {
          await send(.delegate(.requestMapBounds(true)))
          await send(.changeInitialMapLoad(false))
        }
      } else {
        if isCurrentButtonTapped {
          await send(.delegate(.denyLocationPermission))
          await send(.fetchCurrentLocation(false))
        }
        if isIntialLoad {
          await send(.delegate(.requestMapBounds(true)))
          await send(.changeInitialMapLoad(false))
        }
      }
      
    }
  }
}
