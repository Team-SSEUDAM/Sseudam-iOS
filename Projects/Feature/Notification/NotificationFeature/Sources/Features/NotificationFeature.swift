//
//  NotificationFeature.swift
//
//  Notification
//
//  Created by Jiyeon
//

import Foundation
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
    case showRefuseAlert(reason: String)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        state.data = [
          .init(id: 1, userId: 1, type: .visitedSpot, parameterValue: 1, topic: "", contents: "{{닉네임}}님이 제보한 쓰레기통에 쓰레기가 버려졌어요.", readStatus: true, createdAt: Date()),
          .init(id: 1, userId: 1, type: .visitedSpot, parameterValue: 1, topic: "", contents: "{{쓰레기통 이름}}쓰레기통 제보가 승인되었어요.", readStatus: true, createdAt: Date()),
          .init(id: 1, userId: 1, type: .visitedSpot, parameterValue: 1, topic: "", contents: "{{쓰레기통 이름}}쓰레기통 제보가 반려되었어요.", readStatus: true, createdAt: Date())
        ]
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        return .none
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .itemTapped(type):
        switch type {
        case .visitedSpot:
          return .send(.delegate(.showThrowTrash(id: 30)))
        case .approveSuggestion, .approveReport:
          return .send(.delegate(.moveAcceptList))
        case .rejectSuggestion, .rejectReport:
          return .send(.delegate(.showRefuseAlert(reason: "쓰레기통이 없어요")))
        default:
          return .none
        }
        
        
        default: return .none
      }
    }
  }
}
