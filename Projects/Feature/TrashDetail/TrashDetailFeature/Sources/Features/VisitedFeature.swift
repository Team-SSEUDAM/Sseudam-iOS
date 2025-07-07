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
    public var isDenyPermission: Bool = false
    /// 현재 쓰레기통 위치 좌표
    public var trashSpotPoint: Coordinates? = nil
    /// 쓰레기통 ID
    public var trashSpotId: Int? = nil
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case fetchUserLocation
    case setLocationPermission(isDeny: Bool)
    case setTrashSpotInfo(spotId: Int?, point: Coordinates?)
    /// 이전에 남아있던 데이터 초기화
    case initialVisitedData
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
          } else {
            await send(.setLocationPermission(isDeny: true))
          }
        }
        
      case let .setLocationPermission(isDeny):
        state.isDenyPermission = isDeny
        return .none
        
      case let .setTrashSpotInfo(spotId, point):
        state.trashSpotId = spotId
        state.trashSpotPoint = point
        return .none
        
      case .initialVisitedData:
        state.isVisitedButtonEnable = .disabled
        return .merge([
          .send(.setTrashSpotInfo(spotId: nil, point: nil)),
          .send(.setLocationPermission(isDeny: true))
        ])
        
      default: return .none
      }
    }
  }
  
}
