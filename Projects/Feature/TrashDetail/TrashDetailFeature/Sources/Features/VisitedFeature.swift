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
import Foundation

@Reducer
public struct VisitedFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var isVisitedButtonEnable: PrimaryButtonState = .disabled
    public var visitedButtonText: String = "이 곳에 쓰레기 담기"
    public var isDenyPermission: Bool = false
    /// 현재 쓰레기통 위치 좌표
    public var trashSpotPoint: Coordinates? = nil
    /// 쓰레기통 ID
    public var trashSpotId: Int? = nil
    
    var cooldowns: Date? = Date()       // [SpotID: ExpirationTime]
    var remainingTime: TimeInterval? = 300
    var timerText: String? = nil
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
    
    case visitedTimer(AuthenticationAction)
  }
  
  public enum AuthenticationAction: Equatable {
    case startCooldown(String)       // 시작할 장소 ID
    case stopCooldown(String)        // 뷰가 닫힐 때 타이머 종료
    case tick(String)                // 1초마다 호출됨
    case updateRemainingTime(String, TimeInterval) // 상태 업데이트
    case isTimerOver
  }
  
  public enum Delegate: Equatable {
    case showToastMessage(String)
  }
  
  enum TimerID: Hashable {
    case cooldown(String) // 장소 ID 기반
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
        
        
      case let .visitedTimer(action):
        switch action {
        case let .startCooldown(spotId):
          let expireTime = Date().addingTimeInterval(300) // 5분
          state.cooldowns = expireTime
          return startTimer(spotId: spotId)
          
        case let .tick(spotID):
          return timerTick(spotId: spotID, cooldowns: state.cooldowns)
          
        case .isTimerOver:
          state.cooldowns = nil
          state.remainingTime = 0
          return .none
          
        case let .updateRemainingTime(spotID, time):
          state.remainingTime = time
          //          state.timerText = changeTimerFormat(time: time)
          let remainTime = changeTimerFormat(time: time) 
          state.visitedButtonText = "이 곳에 쓰레기 담기(\(remainTime))"
          
          //          print(state.timerText)
          return .none
          
        case let .stopCooldown(spotID):
          return .cancel(id: TimerID.cooldown(spotID))
        }
        
      default: return .none
      }
    }
  }
  
  private func startTimer(spotId: String) -> Effect<Action> {
    return .run { send in
        while true {
          try await Task.sleep(nanoseconds: 1_000_000_000)
          await send(.visitedTimer(.tick(spotId)))
        }
      }
      .cancellable(id: TimerID.cooldown(spotId), cancelInFlight: true)
  }
  
  private func timerTick(spotId: String, cooldowns: Date?) -> Effect<Action> {
    guard let expireTime = cooldowns else {
      return .cancel(id: TimerID.cooldown(spotId))
    }
    let remaining = expireTime.timeIntervalSinceNow
    if remaining <= 0 {
      return .concatenate([
        .send(.visitedTimer(.isTimerOver)),
        .cancel(id: TimerID.cooldown(spotId))
      ])
    } else {
      return .send(.visitedTimer(.updateRemainingTime(spotId, remaining)))
    }
  }
  
  private func changeTimerFormat(time: TimeInterval?) -> String {
    guard let time = time,
          time > 0 else { return "" }
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
  
  private func confirmEnableVisit(isEnable: Bool) -> Effect<Action> {
    if isEnable { // 인증이 가능함
      return .send(.visitedTimer(.startCooldown("1")))
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
          await send(.visitedButtonEnable(true)) // distance <= 5
        } else {
          await send(.visitedButtonEnable(false))
        }
      } else {
        await send(.setLocationPermission(isDeny: true))
      }
    }
  }
  
}
