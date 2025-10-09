//
//  NotificationFeature.swift
//
//  Notification
//
//  Created by Jiyeon
//

import ComposableArchitecture
import NotificationDomainInterface
import UserDefaults

@Reducer
public struct NotificationFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var isLoggedIn: Bool = false
    public var data: [NotificationEntity] = []
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkLoggedIn
    case requestLogin
    case itemTapped(NotificationType)
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestLogin(Bool)
    case showThrowTrash(id: Int)
    case moveAcceptList
    case showRefuseAlert
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.data = [
          .init(contents: "{{닉네임}}님이 제보한 쓰레기통에 쓰레기가 버려졌어요.", date: "2025-10-09T00:01:09.800", type: .trashThrow),
          .init(contents: "ㅇㅇ쓰레기통 제보가 승인되었어요.", date: "2025-10-09T00:01:09.800", type: .accept),
          .init(contents: "ㅇㅇ쓰레기통 제보가 반려되었어요.", date: "2025-10-09T00:01:09.800", type: .refuse)
        ]
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .itemTapped(type):
        switch type {
        case .trashThrow:
          return .send(.delegate(.showThrowTrash(id: 30)))
        case .accept:
          return .send(.delegate(.moveAcceptList))
        case .refuse:
          return .send(.delegate(.showRefuseAlert))
        }
        
        
        default: return .none
      }
    }
  }
}
