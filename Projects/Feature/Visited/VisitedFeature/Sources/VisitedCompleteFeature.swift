//
//  VisitedCompleteFeature.swift
//  VisitedFeature
//
//  Created by Jiyeon on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import DesignKit
import DotLottie
import PetDomainInterface

@Reducer
public struct VisitedCompleteFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    var isFirstVisit: Bool
    var toastMessage: AttributedString? = nil
    var sseudamCount: String
    var animationState: AnimationState = .init()
    var isShowConfetti: Bool = false
    var isShowFirstVisitMessage: Bool = false
    var isShowButton: Bool = false
    var petInfo: PetInfoEntity? = nil
    
    public init(isFirstVisit: Bool, petInfo: PetInfoEntity?) {
      self.isFirstVisit = isFirstVisit
      sseudamCount = isFirstVisit ? "7쓰담" : "5쓰담"
      self.petInfo = petInfo
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case startAnimation
    case startSuccess
    case startConfetti
    case showFirstVisitText
    case showButton
    case comfirmButtonTapped
    case showToastMessage
    case resetToastMessage
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
        return startAnimation(isFirstVisit: state.isFirstVisit)
        
      case .startSuccess:
        let duration = state.animationState.success.duration()
        state.animationState.success.setSpeed(speed: duration / 1.0)
        state.animationState.success.play()
        return .none
        
      case .startConfetti:
        state.isShowConfetti = true
        state.animationState.confetti.play()
        return .none
        
      case .showFirstVisitText:
        state.isShowFirstVisitMessage = true
        return .none
        
      case .showButton:
        state.isShowButton = true
        return .none
        
      case .comfirmButtonTapped:
        return .send(.delegate(.dismiss))
        
      case .showToastMessage:
        var attributed: AttributedString {
          var sseudam = AttributedString(state.sseudamCount)
          var text = AttributedString("이 적립됐어요!")
          sseudam.foregroundColor = ColorSet.Text.InverseAccent
          text.foregroundColor = ColorSet.Text.Inverse
          sseudam.append(text)
          return sseudam
        }
        state.toastMessage = attributed
        return .none
        
      case .resetToastMessage:
        state.toastMessage = nil
        return .none
        
        default: return .none
      }
    }
  }
  
  private func startAnimation(isFirstVisit: Bool) -> Effect<Action> {
    return .run { send in
      await send(.startSuccess)
      try await Task.sleep(nanoseconds: 400_000_000)
      await send(.startConfetti)
      if isFirstVisit {
        try await Task.sleep(nanoseconds: 800_000_000)
        await send(.showFirstVisitText)
      }
      try await Task.sleep(nanoseconds: 800_000_000)
      await send(.showButton)
      try await Task.sleep(nanoseconds: 400_000_000)
      await send(.showToastMessage)
    }
    
  }
}

extension VisitedCompleteFeature {
  
  public struct AnimationState: Equatable {
    var confetti = DotLottieAnimation(
      fileName: LottieSet.confetti.name,
      config: AnimationConfig(autoplay: false, loop: false)
    )
    var success = DotLottieAnimation(
      fileName: LottieSet.success.name,
      config: AnimationConfig(autoplay: false, loop: false)
    )
    
    public static func == (lhs: VisitedCompleteFeature.AnimationState, rhs: VisitedCompleteFeature.AnimationState) -> Bool {
      return true
    }
  }
}
