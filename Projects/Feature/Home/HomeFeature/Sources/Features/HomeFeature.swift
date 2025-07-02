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
import Utility

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
    
    public var isFirstLoad: Bool = true
    public var isExpandedRetry: Bool = false
    public var lastSearchedBounds: [MapPoint]? = nil
    public var toastMessage: String? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    
    case requestMapBounds(Bool)
    case fetchTrashItems([MapPoint])
    case fetchTrashItemsResult(Result<[TrashSpot], NetworkError>)
    case storeTrashItems([TrashSpot])
    case emptyTrashItems
    case firstLoadSearch
    case expandSearch
    
    case filterTapped(TrashType?)
    case researchButtonEnable(Bool)
    case markerTapped(Int?)
    
    case deleteActiveMarker
    case onAppear
    
    case path(StackActionOf<Path>)
    
    case reportButtonTapped
    case presentDetailView(Bool)
    case requestExpandedMapBounds([MapPoint])
    
    case showToastMessage(String?)
    case presentDetailView(Bool, id: Int? = nil)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case presentDetailView(Bool, id: Int?)
    case noDataInDetailView
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
        state.lastSearchedBounds = bounds
        return fetchTrashItem(bounds: bounds, type: state.trashType)
        
      case let .fetchTrashItemsResult(result):
        switch result {
        case let .success(items):
          return .send(.storeTrashItems(items))
        case let .failure(error):
          return .send(.showToastMessage(error.localizedDescription))
        }
        
      case let .storeTrashItems(items):
        state.trashItems.removeAll()
        state.trashItems = items
        if items.isEmpty {
          return .send(.emptyTrashItems)
        } else { // 데이터 있으면 바텀시트 내리기
          return .send(.presentDetailView(false))
        }
        
      case .emptyTrashItems:
        if state.isFirstLoad {
          return .send(.firstLoadSearch)
        } else { // 바텀시트 띄우기
          return .send(.presentDetailView(true, id: nil))
        }
        
      case .firstLoadSearch:
        if !state.isExpandedRetry { // 1회 확장 검색 시도
          state.isExpandedRetry = true
          return .send(.expandSearch)
        } else { // 확장 검색 후에도 없음
          state.isFirstLoad = false
          state.isExpandedRetry = false
          return .send(.showToastMessage("이 근방에는 쓰레기통이 없어요.\n지도를 움직여 다른 위치를 확인해보세요"))
        }
        
      case .expandSearch:
        if let lastBounds = state.lastSearchedBounds {
          return .send(.requestExpandedMapBounds(lastBounds))
        } else {
          return .none
        }
        
      case let .requestExpandedMapBounds(bounds):
          let expandedBounds = expandBounds(bounds, ratio: 0.35) // 확장비율 조정
          return .send(.fetchTrashItems(expandedBounds))
        
      case let .markerTapped(id):
        return .send(.presentDetailView(id != .none, id: id))
        
      case .deleteActiveMarker:
        state.isNeedDeleteMarker = true
        return .none
        
      case let .showToastMessage(message):
        state.toastMessage = message
        return .none
        
        // MARK: - Receive LocationFeature delegate action
        
      case let .location(.delegate(.requestMapBounds(isRequest))):
        return .send(.requestMapBounds(isRequest))
        
        // MARK: - Send Action to HomeRoot
      case .reportButtonTapped:
        state.path.append(.reportView(ReportFeature.State()))
        return .send(.delegate(.needToHiddenTabBar(true)))
        
      case let .presentDetailView(isPresent, id):
        state.isPresentDetail = isPresent
        return .run { send in
          await MainActor.run {
            send(.delegate(.needToHiddenTabBar(isPresent)))
            send(.delegate(.presentDetailView(isPresent, id: id)))
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
        return await send(.fetchTrashItemsResult(.success(result)))
      } catch let error as NetworkError {
        return await send(.showToastMessage(error.localizedDescription))
      }
    }
  }
  
  /// 지도 범위 확장
  private func expandBounds(_ bounds: [MapPoint], ratio: Double) -> [MapPoint] {
      guard bounds.count == 2 else { return bounds }
      let sw = bounds[0]
      let ne = bounds[1]
      let latDelta = ne.latitude - sw.latitude
      let lngDelta = ne.longitude - sw.longitude
      let newSW = MapPoint(
          latitude: sw.latitude - latDelta * ratio,
          longitude: sw.longitude - lngDelta * ratio
      )
      let newNE = MapPoint(
          latitude: ne.latitude + latDelta * ratio,
          longitude: ne.longitude + lngDelta * ratio
      )
      return [newSW, newNE]
  }
}

extension HomeFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case reportView(ReportFeature)
  }
}
