//
//  VisitedFeature.swift
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
    
    public var userLocation: Coordinates? = nil
    
    public var isDenyPermission: Bool = false
    
    public var isWithinDistance: Bool = false // 5m 범위 내에 있는지
    
    public var timer: TimerFeature.State = .init()
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
    /// 방문하기 버튼 탭
    case visitButtonTapped
    /// 인증하기 성공
    case successVisit
    /// 인증 불가능 - 버튼 탭 시
    case disableVisit
    /// 방문하기 상태 변경
    case changeVisitedState(VisitedState)
    
    /// 방문하기 버튼 텍스트 변경
    case changeVisitedButtonText(remainingTime: String?)
    /// 위치 권한 설정 여부
    case setLocationPermission(isDeny: Bool)
    
    case showToastMessage(String?)
    case showAlert(AlertType)
    case delegate(Delegate)
    
    case timer(TimerFeature.Action)
  }
  
  public enum Delegate: Equatable {
    case showToastMessage(String?)
    case showAlert(AlertType)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.timer, action: \.timer) {
      TimerFeature()
    }
    
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .initialVisitedData:
        state.visitedState = .unknown
        return .merge([
          .send(.timer(.timerCancel(state.trashSpotId?.description))), // 타이머 종료
          .send(.changeVisitedButtonText(remainingTime: nil)), // 버튼 텍스트 초기화
          .send(.timer(.initialTimerState)), // 타이머 상태 초기화
          .send(.setTrashSpotInfo(spotId: nil, point: nil)), // 저장된 쓰레기통 데이터 초기화
          .send(.setLocationPermission(isDeny: false)) // 위치 권한 초기화
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
          isDenyPermission: state.isDenyPermission,
          remainingTime: state.timer.remainingTime
        )
        
      case .visitButtonTapped:
        guard state.visitedState == .enableVisit else {
          return .send(.disableVisit)
        }
        // TODO: - 인증하기 api 연결
        return .send(.successVisit)
        
      case .successVisit:
        // 만료 시간 저장
        let expireTime = Date().addingTimeInterval(300)
        let spotId = state.trashSpotId?.description
        saveRemainingTime(key: spotId, value: expireTime)
        return .send(.timer(.startTimer(expireTime: expireTime, spotId: spotId)))
        
      case .disableVisit:
        return handleDisableVisit(state: state.visitedState, time: state.timer.remainingTime)
        
        
      case let .changeVisitedState(visitedState):
        state.visitedState = visitedState
        return . none
        
      case let .changeVisitedButtonText(remainingTime):
        let text: String = "이 곳에 쓰레기 담기"
        if let remainingTime = remainingTime {
          state.visitedButtonText = text+"(\(remainingTime))"
        } else {
          state.visitedButtonText = text
        }
        return .none
        
      case let .setLocationPermission(isDeny):
        state.isDenyPermission = isDeny
        return .none
        
      case let .showToastMessage(message):
        return .send(.delegate(.showToastMessage(message)))
      
        
        // MARK: - Timer
        
      case let .timer(.delegate(action)):
        switch action {
        case let .changeVisitedButtonText(remainingTime):
          return .send(.changeVisitedButtonText(remainingTime: remainingTime))
        }
      default: return .none
        
        
      }
    }
  }
  
  
}

extension VisitedFeature {
  
  private func handleDisableVisit(state: VisitedState, time: TimeInterval? = nil) -> Effect<Action> {
    print("🤓", #function)
    switch state {
    case .remainTime:
      if let time = time {
        var remainTime = Int(time) / 60
        if remainTime < 1 {
          remainTime = Int(time) % 60
          return .send(.showToastMessage("\(remainTime)초 뒤 다시 시도해주세요."))
        } else {
          return .send(.showToastMessage("\(remainTime)분 뒤 다시 시도해주세요."))
        }
       
      }
    case .far:
      return .send(.showToastMessage("인증하려면 쓰레기통 5m 이내로 이동해주세요."))
    case .enableVisit:
      return .none
    case .unknown:
      return .send(.showToastMessage("인증을 시도할 수 없어요."))
    case .denyPermission:
      return .send(.showAlert(.locationPermission))
    }
    return .none
  }
  
  /// 방문 인증 가능 여부 확인, 상태 변경
  private func checkEnableVisit(
    isWithinDistance: Bool,
    isDenyPermission: Bool,
    remainingTime: TimeInterval?
  ) -> Effect<Action> {
    print("🤓", #function)
    guard UserDefaultsKeys.isLoggedIn == true else {
      return .send(.showAlert(.login))
    }
    
    guard remainingTime == .none else { // 시간이 남아있음
      return .send(.changeVisitedState(.remainTime))
    }
    
    guard !isDenyPermission else { // 위치 권한이 없음
      return .send(.changeVisitedState(.denyPermission))
    }
    
    guard isWithinDistance else { // 거리 내에 없음
      return .send(.changeVisitedState(.far))
    }
    
    return .send(.changeVisitedState(.enableVisit))
  }
  
  private func checkRemainVisitedData(spotId: Int?) -> Effect<Action> {
    print("🤓", #function)
    guard let spotId = spotId else {
      return .send(.showToastMessage("쓰레기통 정보를 찾을 수 없어요."))
    }
    
    guard let savedVisitedData = UserDefaultsKeys.visitedSpot else {
      return .send(.checkEnableVisit)
    }
    
    let key = spotId.description
    guard let savedExpireTime = savedVisitedData[key] else {
      return .send(.checkEnableVisit)
    }
    
    if let _ = savedExpireTime.remainingFromNow() {
      return .send(.timer(.startTimer(expireTime: savedExpireTime, spotId: key)))
    }  else {
      saveRemainingTime(key: key, value: nil) // 삭제
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
        await send(.showToastMessage("위치 정보를 확인할 수 없어요"))
      }
    }
  }
}
