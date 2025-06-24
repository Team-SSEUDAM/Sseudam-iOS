//
//  WriteNameFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture


@Reducer
public struct WriteNameFeature {
  
  public init() {
    
  }
  
  public enum TestFieldValidation: Equatable {
    case valid
    case invalid(String)
    case none(String)
  }
  
  @ObservableState
  public struct State: Equatable {
    public var name: String = ""
    public var textFieldState: CustomTextFieldState = .normal
    public var injectedFocus: Bool = false
    public var validation: TestFieldValidation = .none("2~12자까지 입력할 수 있어요.")
    public init() {
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case checkValidName(String)
    case injectedFocus(Bool)
    
    public enum Delegate: Equatable {
      case nameChanged(String)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.name):
        return .send(.checkValidName(state.name))
      case let .checkValidName(name):
        switch name.count {
        case 0: state.validation = .none("2~12자까지 입력할 수 있어요.")
          state.textFieldState = .accent
          return .send(.delegate(.nameChanged("")))
        case 1:
          state.validation = .invalid("이름이 너무 짧습니다")
          state.textFieldState = .error
          return .send(.delegate(.nameChanged("")))
        case 2...12:
          state.validation = .valid
          state.textFieldState = .accent
          return .send(.delegate(.nameChanged(name)))
        default:
          state.validation = .invalid("이름이 너무 깁니다")
          state.textFieldState = .error
          return .send(.delegate(.nameChanged("")))
        }
      case let .injectedFocus(focus):
        state.injectedFocus = focus
        return .none
      default: return .none
      }
    }
  }
}
