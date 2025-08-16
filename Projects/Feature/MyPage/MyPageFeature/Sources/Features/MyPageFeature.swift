//
//  MyPageFeature.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import ComposableArchitecture
import UserDefaults

@Reducer
public struct MyPageFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var path = StackState<MyPagePath.State>()
    public var suggestionList: SuggestionListFeature.State = .init()
    public var thrownList: ThrownListFeature.State = .init()
    
    public var isLoggedIn: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case path(StackActionOf<MyPagePath>)
    case suggestionList(SuggestionListFeature.Action)
    case thrownList(ThrownListFeature.Action)
    
    case onAppear
    case refreshPage
    case checkLoggedIn
    
    case settingButtonTapped
    case changeNicknameButtonTapped
    
    case checkLoginState
    
    case requestLogin
    case hiddenTabBar(Bool)
    case delegate(Delegate)
  }
  
  @Reducer(state: .equatable, action: .equatable)
  public enum MyPagePath {
    case setting(SettingFeature)
    case changeNickname(ChangeMyNicknameFeature)
    case policy(PolicyFeature)
  }
  
  public enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case requestLogin(Bool)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.suggestionList, action: \.suggestionList) {
      SuggestionListFeature()
    }
    Scope(state: \.thrownList, action: \.thrownList) {
      ThrownListFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .refreshPage:
        return forceFetchInitData()
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return state.isLoggedIn ? fetchInitData() : .none
        
      case .settingButtonTapped:
        state.path.append(.setting(SettingFeature.State()))
        return .send(.hiddenTabBar(true))
        
      case .changeNicknameButtonTapped:
        let nickname = UserDefaultsKeys.userNickname
        state.path.append(.changeNickname(ChangeMyNicknameFeature.State(name: nickname)))
        return .send(.hiddenTabBar(true))
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
        
      case let .hiddenTabBar(isHidden):
        return .send(.delegate(.hiddenTabBar(isHidden)))
        
        // MARK: - Setting Delegate Action
      case let .path(.element(id: _, action: .setting(.delegate(action)))):
        switch action {
        case let .movePolicy(type):
          state.path.append(.policy(PolicyFeature.State(type: type)))
          return .none
        case .pop:
          state.path.removeLast()
          return .send(.hiddenTabBar(false))
        }
        
      case let .path(.element(id: _, action: .policy(.delegate(action)))):
        switch action {
        case .pop:
          state.path.removeLast()
          return .none
        }
        
      case let .path(.element(id: _, action: .changeNickname(.delegate(action)))):
        switch action {
        case let .didChangeNickname(nickname):
          UserDefaultsKeys.userNickname = nickname
          return .none
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

extension MyPageFeature {
  private func fetchInitData() -> Effect<Action> {
    return .run { send in
      await send(.suggestionList(.fetchHistories))
      await send(.thrownList(.fetchThrownList))
    }
  }
  
  private func forceFetchInitData() -> Effect<Action> {
    return .run { send in
      await send(.suggestionList(.forceRefreshHistories))
      await send(.thrownList(.forceRefreshThrownList))
    }
  }
}
