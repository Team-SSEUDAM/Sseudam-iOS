//
//  MyPageFeature.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import ComposableArchitecture

@Reducer
public struct MyPageFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var path = StackState<MyPagePath.State>()
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case path(StackActionOf<MyPagePath>)
    
    case settingButtonTapped
    
    case checkLoginState
    
    case requestLogin
    case hiddenTabBar(Bool)
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum MyPagePath {
    case setting(SettingFeature)
  }
  
  public enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .settingButtonTapped:
        state.path.append(.setting(SettingFeature.State()))
        return .send(.hiddenTabBar(true))
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .hiddenTabBar(isHidden):
        return .send(.delegate(.hiddenTabBar(isHidden)))
        
        // MARK: - Setting Delegate Action 
      case let .path(.element(id: _, action: .setting(.delegate(action)))):
        switch action {
        case .pop:
          state.path.removeLast()
          return .send(.hiddenTabBar(false))
        }
        
      default: return .none
        
      }
    }
    .forEach(\.path, action: \.path)
  }
}
