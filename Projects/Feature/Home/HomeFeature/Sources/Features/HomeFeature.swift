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
    public var trashType: TrashType? = nil
    public var researchButtonEnable: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    
    case requestMapBounds(Bool)
    case fetchTrashItems([MapPoint])
    case storeTrashItems([TrashItem])
    case filterTapped(TrashType?)
    case researchButtonEnable(Bool)
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
        
      case let .filterTapped(type):
        // 위치 및 필터 변화 없는 반복 요청
        if type == state.trashType,
            !state.researchButtonEnable {
          return .none
        }
        state.trashType = type
        return .send(.requestMapBounds(true))
      
      case let .requestMapBounds(isRequest):
        state.requestMapBounds = isRequest
        state.researchButtonEnable = false
        print(state.trashType ?? "전체")
        // TODO: - 현위치 검색 api 요청
        return .none
        
      case let .fetchTrashItems(_):
        // TODO: - trash spot API 연결
        if let _ = state.trashType {
          return .send(.storeTrashItems(sampleData2))
        }
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


