//
//  MoveLocationFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility

@Reducer
public struct MoveLocationFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    /// MapView 에 바인딩해 줄 기본 위치(예: Home에서 받은 defaultLocation)
    public var userLocation: ReportMapPoint? = nil
    /// 카메라 Idle 시점의 실제 중앙 좌표
    public var centerLocation: ReportMapPoint? = nil
    /// 중앙 좌표 ➔ 역지오코딩 결과로 보여줄 주소 문자열
    public var address: String = ""
    
    public var isEnabled: Bool = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case onAppear
    /// 카메라가 Idle(멈춤) 상태일 때 델리게이트로부터 전달된 좌표
    case centerChanged(ReportMapPoint)
    case initUserLocation(ReportMapPoint)
    
    public enum Delegate: Equatable {
      case centerChanged(ReportMapPoint)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.isEnabled = false
        return moveUserLocation()
      case let .centerChanged(point):
        state.centerLocation = point
        state.address = "\(point.latitude), \(point.longitude)"
        state.isEnabled = true
        return .send(.delegate(.centerChanged(point)))
      case let .initUserLocation(location):
        state.userLocation = location
        return .none
      default: return .none
      }
    }
  }
}

extension MoveLocationFeature {
  
  private func moveUserLocation() -> Effect<Action> {
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        let userLocation = ReportMapPoint(latitude: location.0, longitude: location.1)
        await send(.initUserLocation(userLocation))
      }
    }
  }
}
