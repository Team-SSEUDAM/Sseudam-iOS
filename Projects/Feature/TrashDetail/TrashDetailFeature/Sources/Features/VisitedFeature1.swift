//
//  VisitedFeature1.swift
//  TrashDetailFeature
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Utility
import DesignKit
import UserDefaults

public enum VisitedState {
  /// 방문 인증 5분 지나지 않음
  case remainTime
  /// 쓰레기통이 멀리(5m 밖)에 있음
  case far
  /// 5m 안 쪽에 있음
  case enableVisit
  
  case unknown
  
  var buttonEnable: Bool {
    self == .enableVisit
  }
  
  
}

@Reducer
public struct VisitedFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var visitedState: VisitedState = .far
    
    public var isVisitedButtonEnable: Bool = false
    
    public var visitedButtonText: String = "이 곳에 쓰레기 담기"
    /// 현재 쓰레기통 위치 좌표
    public var trashSpotPoint: Coordinates? = nil
    /// 쓰레기통 ID
    public var trashSpotId: Int? = nil
    /// 제한 만료 시간
    var expireTime: Date? = Date()
    /// 남은 시간
    var remainingTime: TimeInterval? = nil
    
    var userLocation: Coordinates? = nil
    
    public var isDenyPermission: Bool = false
    
    public var isWithinDistance: Bool = false // 5m 범위 내에 있는지
    
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    /// 이전에 남아있던 데이터 초기화
    case initialVisitedData
    
    case fetchUserLocation
    /// 유저 위치 저장
    case storedUserLocation(Coordinates?)
    /// 쓰레기통 데이터 저장
    case setTrashSpotInfo(spotId: Int?, point: Coordinates?)
    /// 남아있는 방문 인증 정보 확인
    case checkSavedVisitedData
    
   
    /// 유저와 쓰레기통 간의 거리 확인
    case checkDistance(userLocation: Coordinates?)
    /// 5m 내에 있는지 여부 저장
    case storedWithinDistance(Bool)
    /// 방문 인증 가능 여부 확인
    case checkEnableVisit
    
    case changeVisitedState(VisitedState)
    
    case setLocationPermission(isDeny: Bool)
    case showToastMessage(String)
    case delegate(Delegate)
    
    case timer(TimerAction)
  }
  
  public enum Delegate: Equatable {
    case showToastMessage(String)
  }
  
  public enum TimerAction: Equatable {
    /// 시작할 장소 ID
    case startTimer
    /// 뷰가 닫힐 때 타이머 종료
    case stpoTimer
    /// 해당 장소에 5분 내 인증한 적 있는지 여부 체크
    case checkRemainingTime(spotId: Int?)
    /// 1초마다 호출됨
    case tick(String)
    /// 상태 업데이트
    case updateRemainingTime(String, TimeInterval)
    /// 타이머가 끝남
    case isTimerOver
    /// 타이머 동작 중단
    
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
        
      case .initialVisitedData:
        return .merge([
          .send(.setTrashSpotInfo(spotId: nil, point: nil)),
          .send(.setLocationPermission(isDeny: true))
        ])
        
      case .fetchUserLocation:
        return .merge([
          storedUserLocation(),
          .send(.checkEnableVisit)
        ])
        
      case let .setTrashSpotInfo(spotId?, point):
        state.trashSpotId = spotId
        state.trashSpotPoint = point
        return checkRemainVisitedData(spotId: spotId) // 남은 시간 확인 이벤트 연결
        
      case .checkSavedVisitedData:
        return .none
        
        
        
      case let .checkDistance(userLocation):
        return checkDistance(user: userLocation, target: state.trashSpotPoint)
        
      case let .storedWithinDistance(isWithin):
        print("5m내에 존재 \(isWithin)")
        state.isWithinDistance = isWithin
        return .none
        
      case .checkEnableVisit:
        return checkEnableVisit(
          isWithinDistance: state.isWithinDistance,
          remainingTime: state.remainingTime
        )
        
      case let .changeVisitedState(visitedState):
        state.visitedState = visitedState
        return . none
      
        
      
//      case let .timer(action);
//        switch action {
//          
//        }
        
        
      default: return .none
        
        
      }
    }
  }
  
  private func checkEnableVisit(
    isWithinDistance: Bool,
    remainingTime: TimeInterval?
  ) -> Effect<Action> {
    print("🤓", #function)
    guard remainingTime == .none else {
      print("시간이 남아있음")
      return .send(.changeVisitedState(.remainTime))
    }
    
    guard isWithinDistance else {
      print("멀다")
      return .send(.changeVisitedState(.far))
    }
    return .send(.changeVisitedState(.enableVisit))
  }
  
}

// MARK: - Visit Time

extension VisitedFeature {
  private func checkRemainVisitedData(spotId: Int?) -> Effect<Action> {
    print("🤓", #function)
    guard let spotId = spotId else {
      print("쓰레기통 정보를 찾을 수 없어요.")
      return .none
    }
    
    guard let savedVisitedData = UserDefaultsKeys.visitedSpot else {
      print("저장된 데이터가 없음 - 남은 인증 내역이 없음")
      // TODO: - 거리 확인
      return .send(.checkEnableVisit)
    }
    
    let key = spotId.description
    guard let savedTime = savedVisitedData[key] else {
      print("저장된 데이터가 없음 - 해당 장소에 대한 정보 없음")
      return .none
    }
    
    if let _ = savedTime.remainingFromNow() {
      print("시간이 남아있음")
      // TODO: - 타이머 시작
      return .none
    }  else {
      print("시간이 지남.")
      saveRemainingTime(key: key, value: nil) // 삭제
      // TODO: - 거리 확인
      return .send(.checkEnableVisit)
      
    }
    
  }
  
  /// UserDefaults에 저장
  /// value가 nil일 경우 삭제
  private func saveRemainingTime(key: String?, value: Date?) {
    print("🤓", #function)
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

// MARK: - Distance

extension VisitedFeature {
  /// 유저 위치를 저장 및 권한 확인
  private func storedUserLocation() -> Effect<Action> {
    print("🤓", #function)
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        await send(.checkDistance(userLocation: location))
      } else { // 위치 권한이 없음
        await send(.setLocationPermission(isDeny: true))
      }
    }
  }
  
  private func checkDistance(user: Coordinates?, target: Coordinates?) -> Effect<Action> {
    print("🤓", #function)
    return .run { send in
      if let user = user,
         let target = target {
        let isWithin5m =  user.distance(to: target) <= 10
        await send(.storedWithinDistance(isWithin5m))
      } else {
        // TODO: - 토스트
        print("위치 정보를 확인할 수 없어요.")
        
      }
    }
  }
}
