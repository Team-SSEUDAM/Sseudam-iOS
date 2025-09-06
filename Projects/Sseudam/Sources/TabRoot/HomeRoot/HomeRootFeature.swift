//
//  HomeRootFeature.swift
//  Sseudam
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import HomeFeature
import TrashDetailFeature
import DesignKit
import VisitedFeature
import TrashSpotDomainInterface
import PetDomainInterface

@Reducer
struct HomeRootFeature {
  
  @ObservableState
  struct State: Equatable {
    var home: HomeFeature.State = HomeFeature.State()
    var trashDetail: TrashDetailFeature.State? = nil
    var isPresentDetail: Bool = false
    var tempSavingDetailData: TrashSpotDetail? = nil
    var bottomSheetHeight: CGFloat = .detailSheetHeight
    @Presents var modal: ModalDestination.State?
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case home(HomeFeature.Action)
    case trashDetail(TrashDetailFeature.Action)
    
    case presentDetail(Bool, id: Int?)
    case presentVisitedComplete(isFirst: Bool, petInfo: PetInfoEntity?)
    
    case closeAlertAction(AlertType)
    case acceptAlertAction(AlertType)
    
    case hiddenTabBar(Bool)
    case presentAlert(AlertType)
    
    /// 로그인 후 상태 변경하기 위한 action
    case checkLoggedin
    case modal(PresentationAction<ModalDestination.Action>)
    case delegate(Delegate)
    case mixPanel(MixPanel)
  }
  
  enum Delegate: Equatable {
    case hiddenTabBar(Bool)
    case presentAlert(AlertType)
  }
  
  enum MixPanel: Equatable {
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
  }
  
  @Reducer(state: .equatable, action: .equatable)
  enum ModalDestination {
    case visitedComplete(VisitedCompleteFeature)
  }
  
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }
    Reduce { state, action in
      switch action {
        
        // MARK: - Alert
        
      case .closeAlertAction:
        return .none
        
      case let .acceptAlertAction(type):
        switch type {
        case .locationPermission:
          return .send(.home(.moveToSetting))
        default: return .none
        }
        
      case let .hiddenTabBar(isHidden):
        return .send(.delegate(.hiddenTabBar(isHidden)))
        
      case let .presentAlert(type):
        return .send(.delegate(.presentAlert(type)))
        
      case let .presentDetail(isPresent, id):
        state.trashDetail = isPresent ? .init() : nil
        state.isPresentDetail = isPresent
        if isPresent {
          return .send(.trashDetail(.showDetail(id: id)))
        }
        return .none
        
      case let .presentVisitedComplete(isFirst, petInfo):
        state.modal = .visitedComplete(
          VisitedCompleteFeature.State(
            isFirstVisit: isFirst,
            petInfo: petInfo
          )
        )
        return .none
        
      case .checkLoggedin:
        let isNeedRefreshDetail = state.isPresentDetail
        return .run { send in
          if isNeedRefreshDetail {
            await send(.trashDetail(.checkLoggedin))
          }
        }
        
        // MARK: - Receive VisitComplete Delegate Action
      case let .modal(.presented(.visitedComplete(action))):
        switch action {
        case .delegate(.dismiss):
          state.modal = nil
          return .none
        default: return .none
        }
        
        
        // MARK: - Receive HomeFeature Delegate Action
        
      case let .home(.delegate(action)):
        switch action {
        case let .presentDetailView(isPresent, id):
          return .send(.presentDetail(isPresent, id: id))
          
        case let .presentAlert(alert):
          return .send(.presentAlert(alert))

          case let .needToHiddenTabBar(isHidden):
            return .send(.hiddenTabBar(isHidden))
        }
        
      case let .home(.mixPanel(action)):
        switch action {
        case .suggestionStart:
          return .send(.mixPanel(.suggestionStart))
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
          
          
        case .reportStart:
          return .send(.mixPanel(.reportStart))
        case let .reportSelectCategory(repoty_type):
          return .send(.mixPanel(.reportSelectCategory(repoty_type: repoty_type)))
        case .reportCompleteSubmission:
          return .send(.mixPanel(.reportCompleteSubmission))
        }
        // MARK: - Receive TrashDetail Delegate Action
        
      case let .trashDetail(.delegate(action)):
        switch action {
        case let .reportButtonTapped(detailData):
          return .send(.home(.showReportView(detail: detailData)))
          
        case let .showToastMessage(message):
          return .send(.home(.showToastMessage(message)))
          
        case let .showAlert(type):
          return .send(.presentAlert(type))
          
        case let .visitedComplete(isFirst, petInfo):
          return .send(.presentVisitedComplete(isFirst: isFirst, petInfo: petInfo))
          
        case let .bottomSheetHeightChanged(height):
          state.bottomSheetHeight = height
          return .send(.home(.updateBottomSheetHeight(height)))
          
        }
        
      default: return .none
      }
    }
    .ifLet(\.trashDetail, action: \.trashDetail) {
      TrashDetailFeature()
    }
    .ifLet(\.$modal, action: \.modal)
  }
}
