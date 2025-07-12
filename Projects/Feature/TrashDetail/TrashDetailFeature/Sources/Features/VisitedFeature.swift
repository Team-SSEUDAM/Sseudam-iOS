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
import UserDefaults

@Reducer
public struct VisitedFeature2 {
  
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
    /// 제한 만료 시간
    var expireTime: Date? = Date()
    /// 남은 시간
    var remainingTime: TimeInterval? = 300
    
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
    /// 방문하기 버튼 탭
    case visitedButtonTapped
    /// 방문하기 버튼 텍스트 변경
    case changeVisitedButtonText(remainingTime: String?)
    
    case showToastMessage(String)
    case delegate(Delegate)
    
    case visitedTimer(AuthenticationAction)
  }
  
  public enum AuthenticationAction: Equatable {
    /// 시작할 장소 ID
    case startCooldown
    /// 뷰가 닫힐 때 타이머 종료
    case stopCooldown(String)
    /// 해당 장소에 5분 내 인증한 적 있는지 여부 체크
    case checkRemainingTime(spotId: Int?)
    /// 1초마다 호출됨
    case tick(String)
    /// 상태 업데이트
    case updateRemainingTime(String, TimeInterval)
    /// 타이머가 끝남
    case isTimerOver
    /// 타이머 동작 중단
    case stopTimer
  }
  
  public enum Delegate: Equatable {
    case showToastMessage(String)
  }
  
  enum TimerID: Hashable {
    case cooldown(String) // 장소 ID 기반
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case .fetchUserLocation:
        return checkDistanceFromUserLocation(
          target: state.trashSpotPoint,
          remainingTime: state.remainingTime
        )
        
      case let .setLocationPermission(isDeny):
        state.isDenyPermission = isDeny
        return .none
        
      case let .setTrashSpotInfo(spotId, point):
        print("setTrashSpotInfo ", spotId, point)
        state.trashSpotId = spotId
        state.trashSpotPoint = point
        return .send(.visitedTimer(.checkRemainingTime(spotId: spotId)))
        
      case .initialVisitedData:
        return .merge([
          .send(.visitedTimer(.stopTimer)),
          .send(.visitedButtonEnable(false)),
          .send(.setTrashSpotInfo(spotId: nil, point: nil)),
          .send(.setLocationPermission(isDeny: true))
        ])
        
      case let .visitedButtonEnable(isEnable):
        state.isVisitedButtonEnable = isEnable ? .normal : .disabled
        return .none
        
      case .visitedButtonTapped:
        return confirmEnableVisit(
          spotId: state.trashSpotId,
          isEnable: state.isVisitedButtonEnable != .disabled
        )
        
      case let .changeVisitedButtonText(remainingTime):
        let text: String = "이 곳에 쓰레기 담기"
        if let remainingTime = remainingTime {
          state.visitedButtonText = text+"(\(remainingTime))"
        } else {
          state.visitedButtonText = text
        }
        return .none
        
      case let .showToastMessage(msg):
        return .send(.delegate(.showToastMessage(msg)))
        
        
      case let .visitedTimer(action):
        switch action {
          
        case let .startCooldown:
          let expireTime = Date().addingTimeInterval(300) // 5분
          state.expireTime = expireTime
          return startTimer(spotId: state.trashSpotId?.description)
          
        case let .tick(spotID):
          return timerTick(spotId: spotID, cooldowns: state.expireTime)
          
        case .isTimerOver:
          saveRemainingTime(key: state.trashSpotId?.description, value: nil)
          return .send(.changeVisitedButtonText(remainingTime: nil))
          
        case .stopTimer:
          state.expireTime = nil
          state.remainingTime = nil
          return .none
        
        case let .checkRemainingTime(spotId):
          return checkRemainingTime(spotId: spotId)
          
        case let .updateRemainingTime(spotID, time):
          state.remainingTime = time
          let remainTime = changeTimerFormat(time: time)
          return .send(.changeVisitedButtonText(remainingTime: remainTime))
          
        case let .stopCooldown(spotID):
          return .cancel(id: TimerID.cooldown(spotID))
        }
        
      default: return .none
      }
    }
  }
  
  
  /// 5분 내로 방문 여부 파악
  private func checkRemainingTime(spotId: Int?) -> Effect<Action> {
    // 저장된 시간이 있음
    print(#function,  UserDefaultsKeys.visitedSpot, Date())
    if let trashSpotId = spotId,
       let savedData = UserDefaultsKeys.visitedSpot,
       let savedTime = savedData[trashSpotId.description] {
      if let remainingTime = savedTime.remainingFromNow() {
        // 남은 시간이 있다면 버튼에 띄워주기
        print("시간이 남아있음 \(remainingTime)")
        return .send(
          .visitedTimer(.updateRemainingTime(trashSpotId.description, remainingTime))
        )
      } else {
        print("남아있는 시간이 없음")
        return .send(.fetchUserLocation)
        
      }
    }
    return .none
  }
  
  private func startTimer(spotId: String?) -> Effect<Action> {
    guard let spotId = spotId else { return .none }
    print(#function)
    return .run { send in
        while true {
          try await Task.sleep(nanoseconds: 1_000_000_000)
          await send(.visitedTimer(.tick(spotId)))
        }
      }
      .cancellable(id: TimerID.cooldown(spotId), cancelInFlight: true)
  }
  
  
  private func timerTick(spotId: String, cooldowns: Date?) -> Effect<Action> {
    print(#function)
    guard let expireTime = cooldowns else {
      return .cancel(id: TimerID.cooldown(spotId))
    }
    let remaining = expireTime.timeIntervalSinceNow
    if remaining <= 0 {
      return .concatenate([
        .send(.visitedTimer(.stopTimer)),
        .send(.visitedTimer(.isTimerOver)),
        .cancel(id: TimerID.cooldown(spotId))
      ])
    } else {
      return .send(.visitedTimer(.updateRemainingTime(spotId, remaining)))
    }
  }
  
  
  private func confirmEnableVisit(spotId: Int?, isEnable: Bool) -> Effect<Action> {
    print(#function)
    if isEnable { // 인증이 가능함
      // TODO: - 인증 화면 전환
      return completeVistied(spotId: spotId)
    } else {
      // TODO: - 시간이 아직 안지난 경우(n분뒤 사용..) / 거리가 먼 경우
      return .send(.showToastMessage("이용할 수 없어용.."))
    }
  }
  
  private func completeVistied(spotId: Int?) -> Effect<Action> {
    print(#function)
    guard let spotId = spotId else {
      return .send(.showToastMessage("장소를 찾을 수 없어용.."))
    }
    saveRemainingTime(key: spotId.description, value: Date().addingTimeInterval(300))
    return .send(.visitedTimer(.startCooldown))
  }
  
  /// 내 위치와 쓰레기통 위치 거리 비교
  /// - Parameter target: 쓰레기통 좌표
  private func checkDistanceFromUserLocation(target: Coordinates?, remainingTime: TimeInterval?) -> Effect<Action> {
    return .run { send in
      print(#function)
      if let location = await LocationService.shared.userLocation {
        if let target = target,
           location.distance(to: target) <= 5 {
          print("5m 내에 있음")
          if let remainingTime = remainingTime,
             remainingTime > 0 {
            print("시간이 남아있음 \(remainingTime)")
            await send(.visitedButtonEnable(false))
            await send(.visitedTimer(.startCooldown))
          }
          else {
            await send(.visitedButtonEnable(true))
          }
        } else {
          await send(.visitedButtonEnable(false))
        }
      } else {
        await send(.setLocationPermission(isDeny: true))
      }
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
  
  /// UserDefaults에 저장
  /// value가 nil일 경우 삭제
  private func saveRemainingTime(key: String?, value: Date?) {
    print(#function, key, value)
    guard let key = key else { return }
    var dict = UserDefaultsKeys.visitedSpot ?? [:]
    if let value = value {
      dict[key] = value
    } else {
      dict.removeValue(forKey: key)
    }
    UserDefaultsKeys.visitedSpot = dict
  }
  
}
