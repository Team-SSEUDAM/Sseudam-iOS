//
//  TimerFeature.swift
//  TrashDetailFeature
//
//  Created by Jiyeon on 7/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Utility
import UserDefaults

@Reducer
public struct TimerFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    /// 쓰레기통 ID
    public var trashSpotId: String? = nil
    /// 제한 만료 시간
    public var expireTime: Date? = Date()
    /// 남은 시간
    public var remainingTime: TimeInterval? = nil
    
    public init () {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    /// 시작할 장소 ID
    case startTimer(expireTime: Date, spotId: String?)
    /// 1초마다 호출됨
    case tick(String)
    /// 상태 업데이트
    case updateRemainingTime(String, TimeInterval)
    /// 타이머 state 초기화
    case initialTimerState
    /// 타이머가 끝남
    case isTimerOver
    /// 타이머 취소
    case timerCancel(String?)
    
    // MARK: - Delegate
    
    case changeVisitedButtonText(remainingTime: String?)
    case delegate(Delegate)
  }
  
  enum TimerID: Hashable {
    case cooldown(String?) // 장소 ID 기반
  }
  
  public enum Delegate: Equatable {
    case changeVisitedButtonText(remainingTime: String?)
    case checkEnableVisit
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case let .startTimer(expireTime, spotId):
        state.trashSpotId = spotId
        state.expireTime = expireTime
        return startTimer(spotId: spotId?.description)
        
      case let .tick(spotID):
        return timerTick(spotId: spotID, cooldowns: state.expireTime)
        
      case let .updateRemainingTime(_, time):
        state.remainingTime = time
        let remainTime = changeTimerFormat(time: time)
        return .send(.changeVisitedButtonText(remainingTime: remainTime))
        
      case .initialTimerState:
        state.expireTime = nil
        state.remainingTime = nil
        return .cancel(id: state.trashSpotId?.description)
        
      case .isTimerOver:
        return .send(.changeVisitedButtonText(remainingTime: nil))
        
      case let .timerCancel(id):
        return .cancel(id: TimerID.cooldown(id))
        
      case let .changeVisitedButtonText(remainingTime):
        return .send(.delegate(.changeVisitedButtonText(remainingTime: remainingTime)))
      
      default: return .none
      }
      
    }
  }
  
}

extension TimerFeature {
  private func startTimer(spotId: String?) -> Effect<Action> {
//    print("⏱️", #function)
    guard let spotId = spotId else { return .none }
    return .run { send in
        while true {
          try await Task.sleep(nanoseconds: 1_000_000_000)
          await send(.tick(spotId))
        }
      }
      .cancellable(id: TimerID.cooldown(spotId), cancelInFlight: true)
  }
  
  private func timerTick(spotId: String, cooldowns: Date?) -> Effect<Action> {
    guard let expireTime = cooldowns else {
      return .cancel(id: TimerID.cooldown(spotId))
    }
    let remaining = expireTime.timeIntervalSinceNow
    if remaining <= 0 { // 타이머 종료
      return .concatenate([
        .send(.isTimerOver),
        .send(.initialTimerState),
        .send(.delegate(.checkEnableVisit)),
        .cancel(id: TimerID.cooldown(spotId))
      ])
    } else {
      return .send(.updateRemainingTime(spotId, remaining))
    }
  }
  
  /// 남은 시간 string 타입
  private func changeTimerFormat(time: TimeInterval?) -> String {
    guard let time = time,
          time > 0 else { return "" }
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
}
