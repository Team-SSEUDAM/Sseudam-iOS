//
//  MapFeature.swift
//  HomeFeature
//
//  Created by Jiyeon on 7/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import TrashSpotDomainInterface
import DesignKit
import Utility

@Reducer
public struct MapFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    /// 범위 요청 플래그
    public var requestMapBounds: Bool = false
    /// 현위치 재검색 버튼 가능 여부
    public var researchButtonEnable: Bool = false
    /// 조회한 쓰레기통 아이템
    public var trashItems: [TrashSpot] = []
    /// 현재 선택한 쓰레기통 필터 타입 (nil일 경우 전체)
    public var trashType: TrashType? = nil
    /// 활성화 되어있는 마커를 지우기 위한 플래그
    public var isNeedDeleteMarker: Bool = false
    /// 첫 로드 여부
    public var isFirstLoad: Bool = true
    /// 확장 검색 여부
    public var isExpandedRetry: Bool = false
    /// 확장 검색 시도 시 필요한 이전 탐색 범위
    public var lastSearchedBounds: [Coordinates]? = nil
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    /// 범위 요청
    case requestMapBounds(Bool)
    /// 쓰레기통 데이터 조회
    case fetchTrashItems([Coordinates])
    /// 쓰레기통 데이터 조회 Result
    case fetchTrashItemsResult(Result<[TrashSpot], NetworkError>)
    /// 쓰레기통 데이터 저장 및 처리
    case storeTrashItems([TrashSpot])
    /// 쓰레기통 데이터가 없을 경우 처리
    case emptyTrashItems
    /// 첫 진입 직후 아이템 검색
    case firstLoadSearch
    /// 첫 진입 시 아이템 없을 경우 범위 확장
    case requestExpandedMapBounds([Coordinates])
    /// 확장 검색
    case expandSearch
    /// 필터 버튼 탭
    case filterTapped(TrashType?)
    /// 현 위치 재검색
    case researchButtonEnable(Bool)
    /// 마커 탭 이벤트
    case markerTapped(Int?)
    /// 활성화 되어있는 마커 삭제
    case deleteActiveMarker
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    /// 데이터가 없을 경우
    case noDataInDetailView
    case showToastMessage(String?)
    case presentDetailView(Bool, id: Int? = nil)
  }
  
  @Dependency(\.FetchTrashSpotUseCase) var fetchTrashSpotUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .requestMapBounds(isRequest):
        state.requestMapBounds = isRequest
        state.researchButtonEnable = false
        return .none
        
      case let .fetchTrashItems(bounds):
        state.lastSearchedBounds = bounds
        return fetchTrashItem(bounds: bounds, type: state.trashType)
        
      case let .fetchTrashItemsResult(result):
        switch result {
        case let .success(items):
          return .send(.storeTrashItems(items))
        case let .failure(error):
          return .send(.delegate(.showToastMessage(error.localizedDescription)))
        }
        
      case let .storeTrashItems(items):
        state.trashItems.removeAll()
        state.trashItems = items
        if items.isEmpty {
          return .send(.emptyTrashItems)
        } else { // 데이터 있으면 바텀시트 내리기
          return .send(.delegate(.presentDetailView(false)))
        }
        
      case .emptyTrashItems:
        if state.isFirstLoad {
          return .send(.firstLoadSearch)
        } else { // 바텀시트 띄우기
          return .send(.delegate(.presentDetailView(true, id: nil)))
        }
        
      case .firstLoadSearch:
        if !state.isExpandedRetry { // 1회 확장 검색 시도
          state.isExpandedRetry = true
          return .send(.expandSearch)
        } else { // 확장 검색 후에도 없음
          state.isFirstLoad = false
          state.isExpandedRetry = false
          return .send(
            .delegate(.showToastMessage("이 근방에는 쓰레기통이 없어요.\n지도를 움직여 다른 위치를 확인해보세요!"))
          )
        }
        
      case .expandSearch:
        if let lastBounds = state.lastSearchedBounds {
          return .send(.requestExpandedMapBounds(lastBounds))
        } else {
          return .none
        }
        
      case let .filterTapped(type):
        // 위치 및 필터 변화 없는 반복 요청
        if type == state.trashType,
           !state.researchButtonEnable {
          return .none
        }
        state.trashType = type
        return .send(.requestMapBounds(true))
        
      case let .requestExpandedMapBounds(bounds):
        let expandedBounds = expandBounds(bounds, ratio: 1.5) // 확장비율 조정
        return .send(.fetchTrashItems(expandedBounds))
        
     
      case let .markerTapped(id):
        return .send(.delegate(.presentDetailView(id != .none, id: id)))
        
      case .deleteActiveMarker:
        state.isNeedDeleteMarker = true
        return .none
        
      default:
        return .none
      }
      
    }
  }
}

extension MapFeature {
  private func fetchTrashItem(bounds: [Coordinates], type: TrashType?) -> Effect<Action> {
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
        return await send(.delegate(.showToastMessage(error.localizedDescription)))
      } catch {
        return await send(.delegate(.showToastMessage("서버에 연결할 수 없습니다")))
      }
      
    }
  }
  
  /// 지도 범위 확장
  private func expandBounds(_ bounds: [Coordinates], ratio: Double) -> [Coordinates] {
      guard bounds.count == 2 else { return bounds }
      let sw = bounds[0]
      let ne = bounds[1]
      let latDelta = ne.latitude - sw.latitude
      let lngDelta = ne.longitude - sw.longitude
      let newSW = Coordinates(
          latitude: sw.latitude - latDelta * ratio,
          longitude: sw.longitude - lngDelta * ratio
      )
      let newNE = Coordinates(
          latitude: ne.latitude + latDelta * ratio,
          longitude: ne.longitude + lngDelta * ratio
      )
      return [newSW, newNE]
  }
}
