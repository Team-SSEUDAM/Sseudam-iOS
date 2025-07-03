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
    public var map: MapFeature.State = .init()
    
    public var path = StackState<Path.State>()
    public var isPresentDetail: Bool = false
    public var toastMessage: String? = nil
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    case map(MapFeature.Action)
    
    case onAppear
    case path(StackActionOf<Path>)
    
    case showToastMessage(String?)
    case presentDetailView(Bool, id: Int? = nil)
    case presentAlert(AlertType)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case presentDetailView(Bool, id: Int?)
    case presentAlert(AlertType)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.location, action: \.location) {
      LocationFeature()
    }
    Scope(state: \.map, action: \.map) {
      MapFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await MainActor.run {
            send(.location(.fetchUserLocation))
          }
        }
        
      case let .showToastMessage(message):
        state.toastMessage = message
        return .none
        
        // MARK: - Receive LocationFeature delegate action
        
      case let .location(.delegate(.requestMapBounds(isRequest))):
        return .send(.map(.requestMapBounds(isRequest)))
        
      case .location(.delegate(.denyLocationPermission)):
        return .send(.delegate(.presentAlert(.locationPermission)))
        
        // MARK: - Receive MapFeature delegate action
        
      case let .map(.delegate(action)):
        switch action {
        case .noDataInDetailView:
          return .send(.presentDetailView(true, id: nil))
          
        case let .showToastMessage(message):
          return .send(.showToastMessage(message))
          
        case let .presentDetailView(isShow, id):
          return .send(.presentDetailView(isShow, id: id))
        }
        
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
        
      case let .presentAlert(alert):
        return .send(.delegate(.presentAlert(alert)))
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
