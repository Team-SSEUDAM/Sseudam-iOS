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
    case itemTapped(NotificationEntity)
    
    case fetchNotificationItems
    case fetchNotificationResult(Result<NotificationListEntity, NetworkError>)
    
    case readNotification(id: Int)
    case readNotificationResult(Result<Int, NetworkError>)
    
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
  @Dependency(\.ReadNotificationUseCase) private var readNotificationUseCase

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
        
      case let .itemTapped(data):
        print(data.readStatus)
        if data.readStatus {
          return handleTappedItem(type: data.type)
        } else {
          return .concatenate([
            .send(.readNotification(id: data.id)),
            handleTappedItem(type: data.type)
          ])
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
        
      case let .readNotification(id):
        return readNotificationItems(notiId: id)
        
      case let .readNotificationResult(.success(notiId)):
        if let index = state.data.firstIndex(where: { $0.id == notiId }) {
          state.data[index].readStatus = true
        }
        return .none
        
      case .readNotificationResult(.failure(let error)):
        print(error)
        return .none
        
      case let .showToastMessage(message):
        state.toastMessage = message
        return .none
        
        default: return .none
      }
    }
  }
  
  private func handleTappedItem(type: NotificationType) -> Effect<Action> {
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
  
  private func readNotificationItems(notiId: Int) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else { return .none }
    return .run { send in
      do {
        let _ = try await readNotificationUseCase.execute(userId, notiId)
        await send(.readNotificationResult(.success(notiId)))
      } catch let error as NetworkError {
        await send(.readNotificationResult(.failure(error)))
      } catch {
        await send(.readNotificationResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
