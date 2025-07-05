//
//  TrashDetailFeature.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import ComposableArchitecture
import TrashSpotDomainInterface

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
    case storeTrashDetail(TrashSpotDetail)
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
        
      case .fetchTrashDetail:
        return .run { send in
          let data = try await fetchTrashSpotDetailUseCase.execute(1)
          await send(.storeTrashDetail(data))
        }
      case let .storeTrashDetail(data):
        state.trashDetail = data
        return .none
        
        default: return .none
      }
    }
  }
}
