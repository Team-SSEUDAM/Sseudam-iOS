//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import ComposableArchitecture
import HomeDomainInterface

@Reducer
public struct HomeFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var location: LocationFeature.State = .init()
    public var requestMapBounds: Bool = false
    public var trashItems: [TrashItem] = []
    public var trashFilterType: TrashType? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    
    case requestMapBounds(Bool)
    case fetchTrashItems([MapPoint])
    case storeTrashItems([TrashItem])
    case onAppear
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      LocationFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.location(.fetchUserLocation))
            send(.requestMapBounds(true))
          }
        }
      
      case let .requestMapBounds(isRequest):
        state.requestMapBounds = isRequest
        // TODO: - 현위치 재검색 버튼 비활성화 및 api 요청
        return .none
        
      case let .fetchTrashItems(points):
        // TODO: - trash spot API 연결
        dump(points)
        return .send(.storeTrashItems(sampleData))
        
      case let .storeTrashItems(items):
        state.trashItems.removeAll()
        state.trashItems = items
        return .none
        
        
      default: return .none
      }
    }
  }
}


