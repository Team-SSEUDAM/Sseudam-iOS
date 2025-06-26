//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import ComposableArchitecture
import HomeDomainInterface

import ReportFeature
import TrashSpotDomainInterface
import DesignKit

@Reducer
public struct HomeFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var location: LocationFeature.State = .init()
    public var requestMapBounds: Bool = false
    public var trashItems: [TrashSpot] = []
    public var trashType: TrashType? = nil
    public var researchButtonEnable: Bool = false
    public var isNeedDeleteMarker: Bool = false
    public var isPresentDetail: Bool = false
    
    public var path = StackState<Path.State>()
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    
    case requestMapBounds(Bool)
    case fetchTrashItems([MapPoint])
    case storeTrashItems([TrashSpot])
    case filterTapped(TrashType?)
    case researchButtonEnable(Bool)
    case markerTapped(Int?)
    case deleteActiveMarker
    case onAppear
    
    case path(StackActionOf<Path>)
    
    case reportButtonTapped
    case presentDetailView(Bool)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case presentDetailView(Bool)
    case needToHiddenTabBar(Bool)
  }
  
  @Dependency(\.HomeUseCase) var homeUseCase
  @Dependency(\.FetchTrashSpotUseCase) var fetchTrashSpotUseCase
  
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
        print("storeTrashItems ", items.count)
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
      case .reportButtonTapped:
        state.path.append(.reportView(ReportFeature.State()))
        return .send(.delegate(.needToHiddenTabBar(true)))
      case let .presentDetailView(isPresent):
        state.isPresentDetail = isPresent
        return .run { send in
          await MainActor.run {
            send(.delegate(.needToHiddenTabBar(isPresent)))
            send(.delegate(.presentDetailView(isPresent)))
          }
        }
        
      case let .path(action):
        switch action {
        case .element(id: _, action: .reportView(.pop)):
          state.path.removeLast()
          return .none
        default: return .none
        }
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension HomeFeature {
  
  // TODO: - trash spot API 연결
  private func fetchTrashItem(bounds: [MapPoint], type: TrashType?) -> Effect<Action> {
    return .run { send in
      let parameter: FetchTrashSpotParameter = .init(
        region: nil,
        type: type?.rawValue,
        swLat: bounds[0].latitude,
        swLng: bounds[0].longitude,
        neLat: bounds[1].latitude,
        neLng: bounds[1].longitude
      )
      do {
        let result = try await fetchTrashSpotUseCase.execute(parameter)
        return await send(.storeTrashItems(result))
      } catch {
        
      }
    }
  }
}

extension HomeFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case reportView(ReportFeature)
  }
}
