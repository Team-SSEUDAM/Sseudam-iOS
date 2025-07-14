//
//  TrashDetailFeature.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import ComposableArchitecture
import TrashSpotDomainInterface
import Utility
import DesignKit

@Reducer
public struct TrashDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var visited: VisitedFeature.State = .init()
    var isEmptyList: Bool = false
    var trashDetail: TrashSpotDetail? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case visited(VisitedFeature.Action)
    
    case showDetail(id: Int?)
    case noTrashData
    case reportButtonTapped
    
    case setInitVisitedState
    case emptyTrashData(Bool)
    case fetchTrashDetail(id: Int)
    case fetchTrashDetailResult(Result<TrashSpotDetail, NetworkError>)
    
    case showToastMessage(String?)
    case showAlert(AlertType)
  }
  
  public enum Delegate: Equatable {
    case reportButtonTapped(TrashSpotDetail?)
    case showToastMessage(String?)
    case showAlert(AlertType)
  }
  
  @Dependency(\.FetchTrashSpotDetailUseCase) var fetchTrashSpotDetailUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.visited, action: \.visited) {
      VisitedFeature() //._printChanges()
    }
    
    Reduce { state, action in
      switch action {
      case let .showDetail(id):
        if let id = id {
          return .concatenate([
            .send(.emptyTrashData(false)),
            .send(.setInitVisitedState),
            .send(.fetchTrashDetail(id: id))
          ])
        } else {
          return .send(.emptyTrashData(true))
        }
        
      case .setInitVisitedState:
        return .send(.visited(.initialVisitedData))
        
      case let .emptyTrashData(isEmpty):
        state.isEmptyList = isEmpty
        return .none
        
      case .reportButtonTapped:
        return .send(.delegate(.reportButtonTapped(state.trashDetail)))
        
      case let .fetchTrashDetail(id):
        return fetchTrashDetail(id: id)
        
      case let .fetchTrashDetailResult(.success(data)):
        state.trashDetail = data
        return .send(.visited(.setTrashSpotInfo(spotId: data.id, point: data.point)))
        
      case let .fetchTrashDetailResult(.failure(error)):
        print(error)
        state.trashDetail = nil
        return .send(.visited(.initialVisitedData))
        
        
      case let .showToastMessage(message):
        return .send(.delegate(.showToastMessage(message)))
        
      case let .showAlert(type):
        return .send(.delegate(.showAlert(type)))
        
        // MARK: - VisitedFeature Delegate Action
      case let .visited(.delegate(action)):
        switch action {
        case let .showToastMessage(message):
          return .send(.showToastMessage(message))
        case let .showAlert(type):
          return .send(.showAlert(type))
        }
        
        default: return .none
      }
    }
  }
  
  private func fetchTrashDetail(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        let data = try await fetchTrashSpotDetailUseCase.execute(id)
        return await(send(.fetchTrashDetailResult(.success(data))))
      } catch {
        return await(send(.fetchTrashDetailResult(.failure(.customError(message: error.localizedDescription)))))
      }
    }
  }
}
