//
//  AttendanceFeature.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import Foundation
import ComposableArchitecture
import DesignKit
import AttendanceDomainInterface

@Reducer
public struct AttendanceFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var attendanceStatus: AttendanceStatus
    public var continuityCount: Int
    public var isContinuity: Bool
    public var toastMessage: AttributedString? = nil
    public var buttonTitle: String = "확인"
    
    public var showTitle: Bool = false
    public var showDescription: Bool = false
    public var showButton: Bool = false
    public var showToast: Bool = false
    
    public init(_ data: AttendanceEntity) {
      continuityCount = data.continuity
      isContinuity = data.isContinuity
      attendanceStatus = data.status
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case startAnimation
    case showToastMessage(AttributedString?)
    case confirmButtonTapped
    
    case handleContinuityFail
    case nextButtonTapped
    case animation(AttendanceAnimationAction)
    
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }
  
  

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.startAnimation)
        
      case .startAnimation:
        return startAnimaion(isSuccess: state.attendanceStatus != .fail)
        
      case let .showToastMessage(msg):
        state.toastMessage = msg
        return .none
        
      case .confirmButtonTapped:
        return .send(.dismiss)
        
      case .handleContinuityFail:
        state.attendanceStatus = .first
        state.continuityCount = 1
        state.isContinuity = true
        state.showTitle = false
        state.showDescription = false
        return startAnimaion(isSuccess: true)
        
      case let .animation(animation):
        switch animation {
        case .titleMove:
          state.showTitle = true
          return .none
        case .descriptionMove:
          state.showDescription = true
          return .none
        case .showButton:
          state.showButton = true
          return .none
        case .showToastMessage:
          if state.attendanceStatus != .fail {
            return sseudamToast(continuityCnt: state.continuityCount)
          }
          return .none
        }
        
      case .dismiss:
        return .send(.delegate(.dismiss))
        
        default: return .none
      }
    }
  }
  
  private func startAnimaion(isSuccess: Bool) -> Effect<Action> {
    return .run { send in
      try await Task.sleep(for: .seconds(0.4))
      await send(.animation(.titleMove))
      try await Task.sleep(for: .seconds(0.8))
      await send(.animation(.descriptionMove))
      try await Task.sleep(for: .seconds(1.6))
      if isSuccess {
        await send(.animation(.showButton))
        try await Task.sleep(for: .seconds(1.0))
        await send(.animation(.showToastMessage))
      } else {
        await send(.handleContinuityFail)
      }
    }
  }
  
}

extension AttendanceFeature {
  private func sseudamToast(continuityCnt: Int) -> Effect<Action> {
    let point = continuityCnt == 5 ? "5쓰담" : "2쓰담"
    var attributed: AttributedString {
      var sseudam = AttributedString(point)
      var text = AttributedString("이 적립됐어요!")
      sseudam.foregroundColor = ColorSet.Text.InverseAccent
      text.foregroundColor = ColorSet.Text.Inverse
      sseudam.append(text)
      return sseudam
    }
    return .send(.showToastMessage(attributed))
  }
}

extension AttendanceFeature {
  public enum AttendanceAnimationAction: Equatable {
    case titleMove
    case descriptionMove
    case showButton
    case showToastMessage
  }
}
