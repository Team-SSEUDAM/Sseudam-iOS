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
import PetDomainInterface
import Utility
import DotLottie

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
    
    public var animationState: AnimationState = .init()
    public var showConfetti: Bool = false
    public var showTitle: Bool = false
    public var showDescription: Bool = false
    public var showButton: Bool = false
    public var showToast: Bool = false
    public var startLevelAnimation: Bool = false
    public var petInfo: PetInfoEntity? = nil
    public var sseudamPoint: SseudamPoint
    
    public init(_ data: AttendanceEntity, petInfo: PetInfoEntity?) {
      continuityCount = data.continuity
      isContinuity = data.isContinuity
      attendanceStatus = data.status
      sseudamPoint = data.continuity == 5 ? .continuityAttendance : .attendance
      self.petInfo = petInfo
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
        return startAnimaion(status: state.attendanceStatus)
        
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
        return startAnimaion(status: .first)
        
      case let .animation(animation):
        switch animation {
        case .confetti:
          state.animationState.confetti.play()
          state.showConfetti = true
          return .none
          
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
            return sseudamToast(sseudam: state.sseudamPoint)
          }
          return .none
          
        case .levelBar:
          state.startLevelAnimation = true
          return .none
        }
        
      case .dismiss:
        return .send(.delegate(.dismiss))
        
        default: return .none
      }
    }
  }
  
}

extension AttendanceFeature {
  
  
  private func sseudamToast(sseudam: SseudamPoint) -> Effect<Action> {
    let point = sseudam.sseudamText
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
  
  private func startAnimaion(status: AttendanceStatus) -> Effect<Action> {
    return .run { send in
      if status == .continuedSuccess {
        await send(.animation(.confetti))
      }
      try await Task.sleep(for: .seconds(0.4))
      await send(.animation(.titleMove))
      
      try await Task.sleep(for: .seconds(0.4))
      await send(.animation(.descriptionMove))
      
      try await Task.sleep(for: .seconds(0.8))
      if status != .fail {
        await send(.animation(.showButton))
        try await Task.sleep(for: .seconds(0.2))
        
        await send(.animation(.showToastMessage))
        try await Task.sleep(for: .seconds(0.4))
        await send(.animation(.levelBar))
      } else {
        await send(.handleContinuityFail)
      }
    }
  }
}

extension AttendanceFeature {
  public enum AttendanceAnimationAction: Equatable {
    case confetti
    case titleMove
    case descriptionMove
    case showButton
    case showToastMessage
    case levelBar
  }
  
  public struct AnimationState: Equatable {
    var confetti = DotLottieAnimation(
      fileName: LottieSet.confetti.name,
      config: AnimationConfig(autoplay: false, loop: false)
    )
    
    public static func == (lhs: AttendanceFeature.AnimationState, rhs: AttendanceFeature.AnimationState) -> Bool {
      return true
    }
  }
}
