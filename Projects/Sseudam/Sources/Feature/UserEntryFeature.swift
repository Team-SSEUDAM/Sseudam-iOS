//
//  UserEntryFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import UserDefaults
import Utility

import AttendanceFeature
import AttendanceDomainInterface

import PetDomainInterface

@Reducer
struct UserEntryFeature {
  @ObservableState
  struct State {
    @Presents var modal: Modal.State?
    var attendanceInfo: AttendanceEntity? = nil
    var userId: Int
    
    init(userId: Int) {
      self.userId = userId
    }
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case checkComplete
    
    case checkAttendance
    case requestCheckAttendance
    case checkAttendanceResult(Result<AttendanceEntity, NetworkError>)
    
    case fetchPetInfo
    case fetchPetInfoResult(Result<PetInfoEntity, NetworkError>)
    
    case checkLevelUp
    
    case modal(PresentationAction<Modal.Action>)
  }
  
  enum Delegate: Equatable {
    case checkComplete
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum Modal {
    case attendance(AttendanceFeature)
  }
  
  @Dependency(\.AttendanceUseCase) var attendanceUseCase
  @Dependency(\.CheckPetInfoUseCase) var checkPetInfoUseCase
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .checkComplete:
        return .send(.delegate(.checkComplete))
        
        // MARK: - Attendance
      case .checkAttendance:
        return .send(.requestCheckAttendance)
        
      case .requestCheckAttendance:
        return checkAttendance(userId: state.userId)
        
      case let .checkAttendanceResult(.success(data)):
        if data.isToday {
          return .send(.checkComplete)
        } else {
          state.attendanceInfo = data
          return .send(.fetchPetInfo)
        }
        
      case let .checkAttendanceResult(.failure(error)):
        print(error)
        return .send(.checkComplete)
        
        // MARK: - Fetch PetInfo
        
      case .fetchPetInfo:
        return fetchPetInfo()
        
      case let .fetchPetInfoResult(.success(entity)):
        if let attendance = state.attendanceInfo {
          let attendanceState = AttendanceFeature.State(attendance, petInfo: entity)
          state.modal = .attendance(attendanceState)
          return .none
        } else {
          return .send(.checkComplete)
        }
        
      case let .fetchPetInfoResult(.failure(error)):
        print(error.localizedDescription)
        return .send(.requestCheckAttendance)
        
      case .checkLevelUp:
        if UserDefaultsKeys.isNeedLevelUp ?? false {
          // TODO: - modal 연결
          return .none
        } else {
          return .send(.checkComplete)
        }
        
        // MARK: - Attendance Delegate
        
      case let .modal(.presented(.attendance(action))):
        switch action {
        case .delegate(.dismiss):
          state.modal = nil
          return .send(.checkLevelUp)
        default: return .none
        }
        
      default: return .none
      }
    }
    .ifLet(\.$modal, action: \.modal)
  }
}

extension UserEntryFeature {
  
  private func checkAttendance(userId: Int) -> Effect<Action> {
    return .run { send in
      do {
        let result = try await attendanceUseCase.execute(userId)
        await send(.checkAttendanceResult(.success(result)))
      } catch let error as NetworkError {
        await send(.checkAttendanceResult(.failure(error)))
      } catch {
        await send(.checkAttendanceResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func fetchPetInfo() -> Effect<Action> {
    return .run { send in
      do {
        let data = try await checkPetInfoUseCase.execute()
        await send(.fetchPetInfoResult(.success(data)))
      } catch let error as NetworkError {
        await send(.fetchPetInfoResult(.failure(error)))
      } catch {
        await send(.fetchPetInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
