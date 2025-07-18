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

@Reducer
public struct VisitedCompleteFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var isFirstVisit: Bool
    var toastMessage: AttributedString? = nil
    var sseudamCount: String
    public init(isFirstVisit: Bool) {
      self.isFirstVisit = isFirstVisit
      sseudamCount = isFirstVisit ? "7쓰담" : "5쓰담"
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
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
        return .send(.showToastMessage)
        
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
}
