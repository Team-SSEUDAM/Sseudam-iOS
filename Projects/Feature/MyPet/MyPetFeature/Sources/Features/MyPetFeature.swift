//
//  MyPetFeature.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import UserDefaults
import AuthFeature

@Reducer
public struct MyPetFeature {
  
  public init() {}
  
  @ObservableState
  public struct State {
    public var path = StackState<Path.State>()
    
    public var isLoggedIn: Bool = false

    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case path(StackActionOf<Path>)
    case onAppear
    case checkLoggedIn
    
    case petNicknameButtonTapped
    case petDetailButtonTapped
    
    case requestLogin
    case hiddenTabBar(Bool)
    case delegate(Delegate)
    
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case requestLogin(Bool)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .petDetailButtonTapped:
        state.path.append(.petDetail(MyPetDetailFeature.State()))
        return .send(.delegate(.needToHiddenTabBar(true)))
      case .petNicknameButtonTapped:
        print("petNicknameButtonTapped")
        return .none
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .hiddenTabBar(isHidden):
        return .send(.delegate(.needToHiddenTabBar(isHidden)))
        
      case let .path(action):
        switch action {
        case .element(id: _, action: .petDetail(.pop)):
          state.path.removeLast()
          return .none
          
        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension MyPetFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case petDetail(MyPetDetailFeature)
  }
}
