//
//  MoveLocationFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import NMReverseGeocodingDomainInterface

@Reducer
public struct MoveLocationFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    /// MapView 에 바인딩해 줄 기본 위치(예: Home에서 받은 defaultLocation)
    public var userLocation: Coordinates? = nil
    /// 카메라 Idle 시점의 실제 중앙 좌표
    public var centerLocation: Coordinates? = nil
    /// 중앙 좌표 ➔ 역지오코딩 결과로 보여줄 주소 문자열
    public var address: String = ""
    
    public var isEnabled: Bool = false
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case onAppear
    /// 카메라가 Idle(멈춤) 상태일 때 델리게이트로부터 전달된 좌표
    case centerChanged(Coordinates)
    case initUserLocation(Coordinates)
    
    case reverseGeoCode(Coordinates)
    case reverseGeoCodeResult(Result<NMGeoCodeReverseEntity, NetworkError>)
    
    public enum Delegate: Equatable {
      case nowCalculateReverseGeoCode(Bool)
      case centerChanged(_ point: Coordinates?, _ entity: NMGeoCodeReverseEntity?)
    }
  }
  
  @Dependency(\.NMReverseGeoCodeUseCase) var reverseGeoCodeUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.isEnabled = false
        return moveUserLocation()
        
      case let .centerChanged(point):
        state.centerLocation = point
        return .send(.reverseGeoCode(point))
        
      case let .reverseGeoCode(point):
        return reverseGeoCodeEffect(point)
        
      case let .reverseGeoCodeResult(result):
        var point: Coordinates? = nil, entity: NMGeoCodeReverseEntity? = nil
        switch result {
        case let .success(rawEntity):
          state.address = convertReverseGeoCodeToAddress(rawEntity)
          state.isEnabled = true
          entity = rawEntity
          if let center = state.centerLocation { point = center }
        case .failure:
          state.address = "현재 위치 정보를 가져올 수 없습니다."
          state.isEnabled = false
        }
        return .run { [point = point, entity = entity] send in
          await send(.delegate(.nowCalculateReverseGeoCode(false)))
          await send(.delegate(.centerChanged(point, entity)))
        }
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
        let userLocation = Coordinates(latitude: location.0, longitude: location.1)
        await send(.initUserLocation(userLocation))
      }
    }
  }
  
  private func convertReverseGeoCodeToAddress(_ entity: NMGeoCodeReverseEntity) -> String {
    if let road = entity.roadAddress, !road.isEmpty { return road }
    
    let convertLocation = "\(entity.area1) \(entity.area2) \(entity.area3)"
    if let checkLast = entity.area4 {
      return "\(convertLocation) \(checkLast)"
    }
    return convertLocation
  }
  
  private func reverseGeoCodeEffect(
    _ point: Coordinates
  ) -> Effect<Action> {
    return .run { send in
      do {
        await send(.delegate(.nowCalculateReverseGeoCode(true)))
        let input = NMReverseGeoCodeInput(latitude: point.latitude, longitude: point.longitude)
        let entity = try await reverseGeoCodeUseCase.execute(input)
        await send(.reverseGeoCodeResult(.success(entity)))
      } catch is CancellationError {
        await send(.reverseGeoCodeResult(.failure(.taskCancelled)))
      } catch {
        await send(.reverseGeoCodeResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
}
