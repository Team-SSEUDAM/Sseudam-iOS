//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import ComposableArchitecture
import HomeDomainInterface
import DesignKit

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
    public var isNeedDeleteMarker: Bool = false
    public var isPresentDetail: Bool = false
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
    case markerTapped(Int?)
    case deleteActiveMarker
    case onAppear
    
    case presentDetailView(Bool)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case presentDetailView(Bool)
  }
  
  @Dependency(\.HomeUseCase) var homeUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      LocationFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          let test = try await homeUseCase.execute()
          print(test)
          await MainActor.run {
            send(.location(.fetchUserLocation))
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
        // TODO: - 현위치 검색 api 요청
        return .none
        
      case let .fetchTrashItems(bounds):
        return fetchTrashItem(bounds: bounds, type: state.trashType)
        
      case let .storeTrashItems(items):
        state.trashItems.removeAll()
        state.trashItems = items
        return .none
        
      case let .markerTapped(id):
        return .send(.presentDetailView(id != .none))
        
      case .deleteActiveMarker:
        state.isNeedDeleteMarker = true
        return .none
        
        // MARK: - Receive LocationFeature delegate action
        
      case let .location(.delegate(.requestMapBounds(isRequest))):
        return .send(.requestMapBounds(isRequest))

        // MARK: - Send Action to HomeRoot
        
      case let .presentDetailView(isPresent):
        state.isPresentDetail = isPresent
        return .send(.delegate(.presentDetailView(isPresent)))
      default: return .none
      }
    }
  }
}

extension HomeFeature {
  
  // TODO: - trash spot API 연결
  private func fetchTrashItem(bounds: [MapPoint], type: TrashType?) -> Effect<Action> {
    if let _ = type {
      return .send(.storeTrashItems(sampleData2))
    }
    return .none
  }
}
