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
import TrashSpotDomainInterface
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
    public var isFirstLoad: Bool = true
    public var isLoading: Bool = false
    
    public var notificationDetail: NotificationDetailFeature.State = .init()
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case checkLoggedIn
    case requestLogin
    case itemTapped(NotificationEntity)
    
    case fetchNotificationItems(isFirst: Bool)
    case fetchNotificationResult(Result<NotificationListEntity, NetworkError>)
    case refreshNotificationItems
    
    case readNotification(id: Int)
    case readNotificationResult(Result<Int, NetworkError>)
    
    case showToastMessage(String?)
    
    case notificationDetail(NotificationDetailFeature.Action)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case requestLogin(Bool)
    case showThrowTrash(data: TrashSpotDetail)
    case moveAcceptList
    case showRefuseAlert(reason: String)
  }
  
  @Dependency(\.FetchNotificationUseCase) private var fetchNotificationUseCase
  @Dependency(\.ReadNotificationUseCase) private var readNotificationUseCase

  public var body: some ReducerOf<Self> {
    Scope(state: \.notificationDetail, action: \.notificationDetail) {
      NotificationDetailFeature()
    }
    
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        guard state.isLoggedIn,
              state.isFirstLoad else { return .none }
        return .send(.fetchNotificationItems(isFirst: true))
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .itemTapped(data):
        if data.readStatus {
          return .send(.notificationDetail(.handleTappedItem(data)))
        } else {
          return .concatenate([
            .send(.readNotification(id: data.id)),
            .send(.notificationDetail(.handleTappedItem(data)))
          ])
        }
        
      case let .fetchNotificationItems(isFirst):
        guard !state.isLoading else { return .none }
        if isFirst {
          state.isFirstLoad = false
          state.isLoading = true
          return fetchNotificationItems(lastId: state.lastId)
        } else {
          guard let id = state.lastId else { return .none }
          state.isLoading = true
          return fetchNotificationItems(lastId: id)
        }
        
      case let .fetchNotificationResult(.success(data)):
        state.isLoading = false
        if state.lastId == nil || state.data.isEmpty {
          state.data = data.items
        } else {
          let existingIDs = Set(state.data.map { $0.id })
          let newItems = data.items.filter { !existingIDs.contains($0.id) }
          state.data.append(contentsOf: newItems)
        }
        state.lastId = data.nextCursor
        return .none
        
      case let .fetchNotificationResult(.failure(error)):
        print(error)
        state.isLoading = false
        return .send(.showToastMessage(error.localizedDescription))
        
      case .refreshNotificationItems:
        guard !state.isLoading else { return .none }
        state.lastId = nil
        state.data = []
        return .send(.fetchNotificationItems(isFirst: true))
        
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
        
      case let .notificationDetail(.delegate(action)):
        return handleNotificationDetail(action)
        
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
  
  private func handleNotificationDetail(_ action: NotificationDetailFeature.Delegate) -> Effect<Action> {
    switch action {
    case let .showThrowTrash(data):
      return .send(.delegate(.showThrowTrash(data: data)))
    case .moveAcceptList:
      return .send(.delegate(.moveAcceptList))
    case let .showRefuseAlert(reason):
      return .send(.delegate(.showRefuseAlert(reason: reason)))
    case let .showToastMessage(message):
      return .send(.showToastMessage(message))
    }
  }
}
