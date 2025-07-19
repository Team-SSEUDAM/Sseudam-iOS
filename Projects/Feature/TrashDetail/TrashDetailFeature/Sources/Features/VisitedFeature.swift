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
import VisitedDomainInterface

@Reducer
public struct VisitedFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var visitedState: VisitedState = .notDetermine
    
    public var isVisitedButtonEnable: Bool = false
    
    public var visitedButtonState: PrimaryButtonState = .disabled
    
    public var visitedButtonText: String = "이 곳에 쓰레기 담기"
    /// 현재 쓰레기통 위치 좌표
    public var trashSpotPoint: Coordinates? = nil
    /// 쓰레기통 ID
    public var trashSpotId: Int? = nil
    
    public var userLocation: Coordinates? = nil
    
    public var isDenyPermission: Bool = true
    
    public var isWithinDistance: Bool = false // 5m 범위 내에 있는지
    
    public var checkComplete: Bool = false
    
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
    
   
    /// 유저와 쓰레기통 간의 거리 확인
    case checkDistance(userLocation: Coordinates?)
    /// 5m 내에 있는지 여부 저장
    case storedWithinDistance(Bool)
    /// 방문 인증 가능 여부 확인
    case checkEnableVisit
    /// 방문하기 버튼 탭
    case visitButtonTapped
    
    case requestVisitResult(Result<VisitedCompleteEntity, NetworkError>)
    /// 최근 방문 여부 확인
    case checkRemaingTime
    
    case checkRemaingTimeResult(Result<CheckRecentVisitEntity, NetworkError>)
    /// 인증하기 성공
    case successVisit(date: Date?)
    /// 인증 불가능 - 버튼 탭 시
    case disableVisit
    /// 방문하기 상태 변경
    case changeVisitedState(VisitedState)
    
    /// 방문하기 버튼 텍스트 변경
    case changeVisitedButtonText(remainingTime: String?)
    /// 위치 권한 설정 여부
    case setLocationPermission(isDeny: Bool)
    
    case checkComplete
    
    case visitedComplete(isFirst: Bool)
    case showToastMessage(String?)
    case showAlert(AlertType)
    case delegate(Delegate)
    
    case timer(TimerFeature.Action)
  }
  
  public enum Delegate: Equatable {
    case visitedComplete(isFirst: Bool)
    case showToastMessage(String?)
    case showAlert(AlertType)
  }
  
  @Dependency(\.VisitedUseCase) var visitedUseCase
  @Dependency(\.CheckRecentVisitUseCase) var checkRecentVisitUseCase
  
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
          storedUserLocation(isDenyPermission: state.isDenyPermission),
          .send(.checkEnableVisit)
        ])
        
      case let .setTrashSpotInfo(spotId?, point):
        state.trashSpotId = spotId
        state.trashSpotPoint = point
        state.visitedButtonState = .disabled
        return .send(.checkRemaingTime)
        
      case let .checkDistance(userLocation):
        return checkDistance(user: userLocation, target: state.trashSpotPoint)
        
      case let .storedWithinDistance(isWithin):
        state.isWithinDistance = isWithin
        return .none
        
      case .checkEnableVisit:
        if !state.checkComplete { return .none }
        return checkEnableVisit(
          isWithinDistance: state.isWithinDistance,
          isDenyPermission: state.isDenyPermission,
          expiredTime: state.timer.expireTime
        )
        
      case .visitButtonTapped:
        guard state.visitedState == .enableVisit else {
          return .send(.disableVisit)
        }
        
        guard let spotId = state.trashSpotId else {
          return .send(.showToastMessage("쓰레기통 정보를 불러오지 못했어요"))
        }
        return requestVisited(spotId: spotId)
        
      case let .requestVisitResult(.success(result)):
        return .merge([
          .send(.visitedComplete(isFirst: result.isTodayFirst)),
          .send(.successVisit(date: result.visitedAt))
        ])
        
      case let .requestVisitResult(.failure(error)):
        state.checkComplete = true
        return .send(.showToastMessage(error.localizedDescription))
        
      case .checkRemaingTime:
        return checkRecentVisit(spotId: state.trashSpotId)
        
      case let .checkRemaingTimeResult(.success(result)):
        state.checkComplete = true
        return handleExistRemaingTime(data: result, spotId: state.trashSpotId)
        
      case let .checkRemaingTimeResult(.failure(error)):
        print(error.localizedDescription)
        state.checkComplete = true
        return .send(.checkEnableVisit)
        
      case let .successVisit(date):
        // 만료 시간 저장
        let date: Date = date ?? .init()
        let expireTime = date.addingTimeInterval(300)
        let spotId = state.trashSpotId?.description
        return .send(.timer(.startTimer(expireTime: expireTime, spotId: spotId)))
        
      case .disableVisit:
        return handleDisableVisit(state: state.visitedState, time: state.timer.remainingTime)
        
        
      case let .changeVisitedState(visitedState):
        state.visitedState = visitedState
        state.visitedButtonState = visitedState == .enableVisit ? .normal : .disabled
        return .none
        
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
        
      case .checkComplete:
        state.checkComplete = true
        return .none
        
      case let .showToastMessage(message):
        return .send(.delegate(.showToastMessage(message)))
      
      case let .showAlert(type):
        return .send(.delegate(.showAlert(type)))
        
      case let .visitedComplete(isFirst):
        return .send(.delegate(.visitedComplete(isFirst: isFirst)))
        
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
  
  private func requestVisited(spotId: Int) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else {
      return .send(.showToastMessage("유저 정보를 조회할 수 없어요"))
    }
    
    return .run { send in
      do {
        let date = try await visitedUseCase.execute(userId, spotId)
        return await send(.requestVisitResult(.success(date)))
      } catch let error as NetworkError {
        return await send(.requestVisitResult(.failure(error)))
      } catch {
        return await send(.requestVisitResult(.failure(.customError(message: "방문 인증에 실패했어요"))))
      }
    }
  }
  
  /// 방문 여부 조회
  private func checkRecentVisit(spotId: Int?) -> Effect<Action> {
    guard let spotId = spotId else {
      return .send(.showToastMessage("쓰레기통 정보를 불러오지 못했어요"))
    }
    guard let userId = UserDefaultsKeys.userId else {
      return .send(.checkEnableVisit)
    }
    return .run { send in
      do {
        let data = try await checkRecentVisitUseCase.execute(userId, spotId)
        return await send(.checkRemaingTimeResult(.success(data)))
      } catch let error as NetworkError {
        return await send(.checkRemaingTimeResult(.failure(error)))
      } catch {
        return await send(.checkRemaingTimeResult(.failure(.customError(message: "인증 정보를 불러오는데 실패했어요."))))
      }
    }
  }
  
  /// 남은 시간 조회 후 로직
  private func handleExistRemaingTime(data: CheckRecentVisitEntity, spotId: Int?) -> Effect<Action> {
    print("🤓", #function)
    if data.isExpired { // 방문 한 적 있음, 5분 지남
      return .send(.checkEnableVisit)
    } else {
      guard let spotId = spotId?.description else {
        return .send(.showToastMessage("쓰레기통 정보를 불러오지 못했어요"))
      }
      guard let expiredAt = data.expiredAt else {
        return .send(.checkEnableVisit)
      }
      return .send(.timer(.startTimer(expireTime: expiredAt, spotId: spotId)))
    }
  }
  
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
    case .auth:
      return .send(.showAlert(.login))
    case .notDetermine:
      return .none
    }
    return .none
  }
  
  /// 방문 인증 가능 여부 확인, 상태 변경
  private func checkEnableVisit(
    isWithinDistance: Bool,
    isDenyPermission: Bool,
    expiredTime: Date?
  ) -> Effect<Action> {
    print("🤓", #function)
    guard UserDefaultsKeys.isLoggedIn == true else {
      return .send(.changeVisitedState(.auth))
    }
    
    guard expiredTime == .none else { // 시간이 남아있음
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
  
  
}

// MARK: - Distance

extension VisitedFeature {
  /// 유저 위치를 저장 및 권한 확인
  private func storedUserLocation(isDenyPermission: Bool) -> Effect<Action> {
    print("🤓", #function)
    return .run { send in
      if let location = await LocationService.shared.userLocation {
        
        if isDenyPermission { // 권한이 변경된 경우 상태 변경 처리
          await send(.setLocationPermission(isDeny: false))
        }
        await send(.checkDistance(userLocation: location))
      } else { // 위치 권한이 없음
        if !isDenyPermission { // 권한이 변경된 경우 상태 변경 처리
          await send(.setLocationPermission(isDeny: true))
        }
      }
    }
  }
  
  private func checkDistance(user: Coordinates?, target: Coordinates?) -> Effect<Action> {
    print("🤓", #function)
    return .run { send in
      if let user = user,
         let target = target {
        let distance = user.distance(to: target)
        print("distance: \(distance)")
        let isWithin5m = distance <= 10
        await send(.storedWithinDistance(isWithin5m))
      } else {
        await send(.showToastMessage("위치 정보를 확인할 수 없어요"))
      }
    }
  }
}
