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
import SuggestionDomainInterface
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
    
    case fetchSuggestionRejectReason(id: Int)
    case fetchSuggestionRejectReasonResult(Result<String, NetworkError>)
    
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
  @Dependency(\.SuggestionDetailUseCase) private var suggestionDetailUseCase

  public var body: some ReducerOf<Self> {
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
          return handleTappedItem(data)
        } else {
          return .concatenate([
            .send(.readNotification(id: data.id)),
            handleTappedItem(data)
          ])
        }
        
      case let .fetchSuggestionRejectReason(suggestionId):
        return fetchSuggestionRejectReason(suggestionId: suggestionId)
        
      case let .fetchSuggestionRejectReasonResult(.success(reason)):
        return .send(.delegate(.showRefuseAlert(reason: reason)))
      
      case let .fetchSuggestionRejectReasonResult(.failure(error)):
        return .none
        
      case let .fetchNotificationItems(isFirst):
        guard !state.isLoading else { return .none }
        if isFirst {
          state.isLoading = true
          return fetchNotificationItems(lastId: state.lastId)
        } else {
          guard let id = state.lastId else { return .none }
          state.isLoading = true
          return fetchNotificationItems(lastId: id)
        }
        
      case let .fetchNotificationResult(.success(data)):
        state.isLoading = false
        state.data.append(contentsOf: data.items)
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
        
        default: return .none
      }
    }
  }
  
  private func handleTappedItem(_ entity: NotificationEntity) -> Effect<Action> {
    switch entity.type {
    case .visitedSpot:
      return .send(.delegate(.showThrowTrash(id: 30)))
    case .approveSuggestion, .approveReport:
      return .send(.delegate(.moveAcceptList))
    case .rejectSuggestion:
      return .send(.fetchSuggestionRejectReason(id: entity.parameterValue))
    case .rejectReport:
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
  
  private func fetchSuggestionRejectReason(suggestionId: Int) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else { return .none }
    return .run { send in
      do {
        let data = try await suggestionDetailUseCase.execute(userId, suggestionId)
        await send(.fetchSuggestionRejectReasonResult(.success(data.rejectReason)))
      } catch let error as NetworkError {
        await send(.fetchSuggestionRejectReasonResult(.failure(error)))
      } catch {
        await send(.fetchSuggestionRejectReasonResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
