//
//  TrashDetailFeature.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import ComposableArchitecture

@Reducer
public struct TrashDetailFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    var id: Int?
    var isEmptyList: Bool = false
    public init(id: Int?, isEmptyList: Bool = false) {
      self.id = id
      self.isEmptyList = id == .none
      
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case showDetail(id: Int?)
    case noTrashData
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .showDetail(id):
        if let id = id {
          state.isEmptyList = false
        } else {
          return .send(.noTrashData)
        }
        // TODO: - api 연결
        
        return .none
        
      case .noTrashData:
        state.isEmptyList = true
        return .none
      
        default: return .none
      }
    }
  }
}
