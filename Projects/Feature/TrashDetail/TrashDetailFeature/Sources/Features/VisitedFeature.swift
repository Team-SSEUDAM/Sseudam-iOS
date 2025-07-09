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
    /// 방문하기 버튼 가능 여부
    case visitedButtonEnable(Bool)
    
    case visitedButtonTapped
    
    case showToastMessage(String)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showToastMessage(String)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchUserLocation:
        return checkDistanceFromUserLocation(target: state.trashSpotPoint)
        
      case let .setLocationPermission(isDeny):
        state.isDenyPermission = isDeny
        return .none
        
      case let .setTrashSpotInfo(spotId, point):
        state.trashSpotId = spotId
        state.trashSpotPoint = point
        return .none
        
      case .initialVisitedData:
        return .merge([
          .send(.visitedButtonEnable(false)),
          .send(.setTrashSpotInfo(spotId: nil, point: nil)),
          .send(.setLocationPermission(isDeny: true))
        ])
        
      case let .visitedButtonEnable(isEnable):
        state.isVisitedButtonEnable = isEnable ? .normal : .disabled
        return .none
        
      case .visitedButtonTapped:
        return confirmEnableVisit(isEnable: state.isVisitedButtonEnable != .disabled)
        
      case let .showToastMessage(msg):
        return .send(.delegate(.showToastMessage(msg)))
        
      default: return .none
      }
    }
  }
  
  private func confirmEnableVisit(isEnable: Bool) -> Effect<Action> {
    if isEnable { // 인증이 가능함
      return .none
    } else {
      // TODO: - 시간이 아직 안지난 경우(n분뒤 사용..) / 거리가 먼 경우
      return .send(.showToastMessage("이용할 수 없어용.."))
    }
  }
  
  
  /// 내 위치와 쓰레기통 위치 거리 비교
  /// - Parameter target: 쓰레기통 좌표
  private func checkDistanceFromUserLocation(target: Coordinates?) -> Effect<Action> {
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        if let target = target {
          let distance = location.distance(to: target)
          await send(.visitedButtonEnable(distance <= 5))
        } else {
          await send(.visitedButtonEnable(false))
        }
      } else {
        await send(.setLocationPermission(isDeny: true))
      }
    }
  }
  
}
