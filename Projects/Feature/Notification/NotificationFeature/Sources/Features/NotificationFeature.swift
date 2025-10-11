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
import Utility

@Reducer
public struct NotificationFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var isLoggedIn: Bool = false
    public var data: [NotificationEntity] = []
    public var lastId: Int? = nil
    public var toastMessage: String? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkLoggedIn
    case requestLogin
    case itemTapped(NotificationType)
    
    case fetchNotificationItems
    case fetchNotificationResult(Result<NotificationListEntity, NetworkError>)
    
    case showToastMessage(String?)
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestLogin(Bool)
    case showThrowTrash(id: Int)
    case moveAcceptList
    case showRefuseAlert(reason: String)
  }
  
  @Dependency(\.FetchNotificationUseCase) private var fetchNotificationUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        if state.isLoggedIn {
          return .send(.fetchNotificationItems)
        } else {
          return .none
        }
        
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
        
      case .fetchNotificationItems:
        return fetchNotificationItems(lastId: state.lastId)
        
      case let .fetchNotificationResult(.success(data)):
        state.data.append(contentsOf: data.items)
        state.lastId = data.nextCursor
        return .none
        
      case let .fetchNotificationResult(.failure(error)):
        print(error)
        return .send(.showToastMessage(error.localizedDescription))
        
      case let .showToastMessage(message):
        state.toastMessage = message
        return .none
        
        default: return .none
      }
    }
  }
  
  private func fetchNotificationItems(lastId: Int?) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else { return .none }
    return .run { send in
      let parameter: FetchNotificationParameter = .init(userId: userId, size: 20, lastId: lastId)
      do {
        if let data = try await fetchNotificationUseCase.execute(parameter) {
          await send(.fetchNotificationResult(.success(data)))
        }
        
      } catch let error as NetworkError {
        await send(.fetchNotificationResult(.failure(error)))
      } catch {
        await send(.fetchNotificationResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
