//
//  HomeReducer.swift
//
//  Home
//
//  Created by JiYeon
//

import ComposableArchitecture

import ReportFeature
import TrashSpotDomainInterface
import SuggestionFeature
import DesignKit
import Utility
import UserDefaults
import UIKit

@Reducer
public struct HomeFeature {
  
  public init() {}
  
  @Dependency(\.openURL) var openURL
  
  @ObservableState
  public struct State: Equatable {
    public var location: LocationFeature.State = .init()
    public var map: MapFeature.State = .init()
    
    public var isHiddenReportButton: Bool = false
    public var path = StackState<Path.State>()
    public var isPresentDetail: Bool = false
    public var isShowSuggestionCoachMark: Bool = UserDefaultsKeys.coachMark_suggestion ?? true
    public var toastMessage: String? = nil
    public var isInitAppear: Bool = true
    public var bottomSheetHeight: CGFloat = .detailSheetHeight + .Number10
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case location(LocationFeature.Action)
    case map(MapFeature.Action)
    case path(StackActionOf<Path>)
    
    case onAppear
    case checkIsLoggined
    case showToastMessage(String?)
    case presentDetailView(Bool, id: Int? = nil)
    case presentAlert(AlertType)
    case hiddenReportButton(Bool)
    
    case removeSuggestionCoachMark
    
    case showReportView(detail: TrashSpotDetail?)
    case moveToSetting
    case moveToSuggestion
    case suggestionButtonTapped
    case delegate(Delegate)
    case mixPanel(MixPanel)
    case updateBottomSheetHeight(CGFloat)
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case presentDetailView(Bool, id: Int?)
    case presentAlert(AlertType)
  }
  
  public enum MixPanel: Equatable {
    case suggestionStart
    case suggestionClickLocation
    case suggestionSetLocation
    case suggestionInputName(description_length: Int)
    case suggestionSelectCategory(trash_type: String)
    case suggestionUploadPhoto(file_size: Int, photo_type: String)
    case suggestionCompleteSubmission(submission_id: Int)
    
    case reportStart
    case reportSelectCategory(repoty_type: String)
    case reportCompleteSubmission
    case category(categoryType: MPCategoryType, userLogin: Bool)
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
        if state.isInitAppear {
          state.isInitAppear = false
          return .send(.location(.moveUserLocation))
        }
        return .none
        
      case .checkIsLoggined:
        return UserDefaultsKeys.isLoggedIn == true
        ? .send(.moveToSuggestion)
        : .send(.presentAlert(.login))
        
      case .suggestionButtonTapped:
        return .send(.checkIsLoggined)
        
      case let .showToastMessage(message):
        state.toastMessage = message
        return .none
        
        // MARK: - Receive LocationFeature delegate action
        
      case let .location(.delegate(.requestMapBounds(isRequest))):
        return .send(.map(.requestMapBounds(isRequest)))
        
      case .location(.delegate(.denyLocationPermission)):
        return .send(.presentAlert(.locationPermission))
        
        // MARK: - Receive MapFeature delegate action
        
      case let .map(.delegate(action)):
        switch action {
        case .noDataInDetailView:
          return .send(.presentDetailView(true))
          
        case let .showToastMessage(message):
          return .send(.showToastMessage(message))
          
        case let .presentDetailView(isShow, id):
          return .send(.presentDetailView(isShow, id: id))
        }
        
      case let .map(.mixPanel(event)):
        switch event {
        case let .category(category, userLogin):
          return .send(.mixPanel(.category(categoryType: category, userLogin: userLogin)))
        }
        
      case let .hiddenReportButton(isHidden):
        state.isHiddenReportButton = isHidden
        return .none
        
      case .removeSuggestionCoachMark:
        UserDefaultsKeys.coachMark_suggestion = false
        state.isShowSuggestionCoachMark = false
        return .none
        
      case let .showReportView(detail):
        guard let detail = detail else { return .none }
        state.path.append(
          .reportView(
            ReportFeature.State(
              detail,
              currentLocation: state.location.lastCameraPosition
            )
          )
        )
        return .merge(
          .send(.presentDetailView(false)),
          .send(.mixPanel(.reportStart))
        )
        // MARK: - Send Action to HomeRoot
        
      case .moveToSuggestion:
        let suggestionState = SuggestionFeature.State(state.location.lastCameraPosition)
        state.path.append(.suggestionView(suggestionState))
        return .merge(
          .send(.delegate(.needToHiddenTabBar(true))),
          .send(.mixPanel(.suggestionStart))
        )
        
        // MARK: - Send Action to HomeRoot
      
      case let .presentDetailView(isPresent, id):
        state.isPresentDetail = isPresent
        if isPresent { state.isShowSuggestionCoachMark = false }
        let isPathEmpty = state.path.isEmpty
        return .run { send in
          await MainActor.run {
            if isPathEmpty { send(.delegate(.needToHiddenTabBar(isPresent))) }
            send(.delegate(.presentDetailView(isPresent, id: id)))
          }
          
          try await Task.sleep(for: .seconds(isPresent ? 0 : 0.13))
          await MainActor.run {
            send(.hiddenReportButton(isPresent))
          }
        }
        
      case let .path(action):
        switch action {
          // MARK: - Suggestion Action
        case .element(id: _, action: .suggestionView(.pop)):
          state.path.removeLast()
          return .none
          
        case let .element(id: _, action: .suggestionView(.mixPanel(ev))):
          switch ev {
          case .suggestionClickLocation:
            return .send(.mixPanel(.suggestionClickLocation))
          case .suggestionSetLocation:
            return .send(.mixPanel(.suggestionSetLocation))
          case let .suggestionInputName(description_length):
            return .send(.mixPanel(.suggestionInputName(description_length: description_length)))
          case let .suggestionSelectCategory(trash_type):
            return .send(.mixPanel(.suggestionSelectCategory(trash_type: trash_type)))
          case let .suggestionUploadPhoto(file_size, photo_type):
            return .send(.mixPanel(.suggestionUploadPhoto(file_size: file_size, photo_type: photo_type)))
          case let .suggestionCompleteSubmission(submission_id):
            return .send(.mixPanel(.suggestionCompleteSubmission(submission_id: submission_id)))
          }
          
          // MARK: - Report Action
        case let .element(id: _, action: .reportView(.pop(detail))):
          state.path.removeLast()
          return .send(.presentDetailView(true, id: detail.id))
          
        case let .element(id: _, action: .reportView(.mixPanel(ev))):
          switch ev {
          case let .reportSelectCategory(repoty_type):
            return .send(.mixPanel(.reportSelectCategory(repoty_type: repoty_type)))
          case .reportCompleteSubmission:
            return .send(.mixPanel(.reportCompleteSubmission))
          }
          
        default: return .none
        }
        
      case let .presentAlert(alert):
        return .send(.delegate(.presentAlert(alert)))
        
      case .moveToSetting:
        return .run { send in
          if let url = URL(string: UIApplication.openSettingsURLString) {
            await openURL(url)
          }
        }
        
      case let .updateBottomSheetHeight(height):
        state.bottomSheetHeight = height + .Number10
        return .none
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension HomeFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case reportView(ReportFeature)
    case suggestionView(SuggestionFeature)
  }
}
