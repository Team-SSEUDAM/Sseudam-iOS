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

@Reducer
public struct TrashDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var isEmptyList: Bool = false
    var trashDetail: TrashSpotDetail? = nil
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showDetail(id: Int?)
    case noTrashData
    case fetchTrashDetail(id: Int)
    case fetchTrashDetailResult(Result<TrashSpotDetail, NetworkError>)
  }
  
  @Dependency(\.FetchTrashSpotDetailUseCase) var fetchTrashSpotDetailUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .showDetail(id):
        if let id = id {
          state.isEmptyList = false
          return .send(.fetchTrashDetail(id: id))
        } else {
          return .send(.noTrashData)
        }
        
      case .noTrashData:
        state.isEmptyList = true
        return .none
        
      case let .fetchTrashDetail(id):
        return fetchTrashDetail(id: id)
        
      case let .fetchTrashDetailResult(.success(data)):
        state.trashDetail = data
        return .none
        
      case let .fetchTrashDetailResult(.failure(error)):
        print(error)
        return .none
        
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
