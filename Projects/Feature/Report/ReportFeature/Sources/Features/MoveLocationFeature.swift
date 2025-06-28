//
//  MoveLocationFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Utility
import ReportDomainInterface

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
    
    case reverseGeoCode(ReportMapPoint)
    case reverseGeoCodeResult(Result<String, NetworkError>)
    
    public enum Delegate: Equatable {
      case centerChanged(ReportMapPoint?)
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
        return .run { send in
          do {
            let input = NMReverseGeoCodeInput(latitude: point.latitude, longitude: point.longitude)
            let address = try await reverseGeoCodeUseCase.execute(input)
            await send(.reverseGeoCodeResult(.success(address)))
          } catch is CancellationError {
            await send(.reverseGeoCodeResult(.failure(.taskCancelled)))
          } catch {
            await send(.reverseGeoCodeResult(.failure(.customError(message: error.localizedDescription))))
          }
        }
      case let .reverseGeoCodeResult(result):
        switch result {
        case let .success(address):
          state.address = address
          state.isEnabled = true
          if let point = state.centerLocation {
            return .send(.delegate(.centerChanged(point)))
          }
        case let .failure(error):
          state.address = "현재 위치 정보를 가져올 수 없습니다."
          state.isEnabled = false
        }
        return .send(.delegate(.centerChanged(nil)))
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
