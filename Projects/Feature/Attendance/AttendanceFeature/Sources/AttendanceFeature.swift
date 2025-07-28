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
    
    public init(_ data: AttendanceEntity) {
      continuityCount = data.continuity
      isContinuity = data.isContinuity
      attendanceStatus = data.status
      if data.status == .fail {
        buttonTitle = "다음"
      }
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case showToastMessage(AttributedString?)
    case confirmButtonTapped
    
    case handleContinuityFail
    case nextButtonTapped
    
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
        if state.attendanceStatus != .fail {
          return sseudamToast(continuityCnt: state.continuityCount)
        }
        return .none
        
      case let .showToastMessage(msg):
        state.toastMessage = msg
        return .none
        
      case .confirmButtonTapped:
        return .send(.dismiss)
        
      case .handleContinuityFail:
        state.buttonTitle = "확인"
        state.attendanceStatus = .first
        state.continuityCount = 1
        state.isContinuity = true
        return sseudamToast(continuityCnt: 1)
        
      case .dismiss:
        return .send(.delegate(.dismiss))
        
        default: return .none
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
