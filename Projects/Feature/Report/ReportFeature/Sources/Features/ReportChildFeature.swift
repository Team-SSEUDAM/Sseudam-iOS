//
//  ReportChildFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 7/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility
import NMReverseGeocodingDomainInterface
import SuggestionDomainInterface
import TrashSpotDomainInterface

import SelectSpotImageFeature
import SelectSpotCategoryFeature
import SelectSpotNameFeature
import SelectSpotLocationFeature
import SpotSuggestionCompleteFeature

// MARK: - Child Reducer
@Reducer
public struct ReportChildFeature {
  
  @ObservableState
  public struct State: Equatable {
    var moveLocation: SelectSpotLocationFeature.State
    var writeName: SelectSpotNameFeature.State = SelectSpotNameFeature.State()
    var selectKind: SelectSpotCategoryFeature.State = SelectSpotCategoryFeature.State()
    var selectPhoto: SelectSpotImageFeature.State = SelectSpotImageFeature.State()
    var complete: SpotSuggestionCompleteFeature.State = SpotSuggestionCompleteFeature.State()
    
    var trashSpotDetail: TrashSpotDetail
    public init(
      _ trashSpotDetail: TrashSpotDetail,
      currentLocation: Coordinates? = nil
    ) {
      self.trashSpotDetail = trashSpotDetail
      self.moveLocation = SelectSpotLocationFeature.State(currentLocation)
    }
  }
  
  public enum Action: Equatable {
    case moveLocation(SelectSpotLocationFeature.Action)
    case writeName(SelectSpotNameFeature.Action)
    case selectKind(SelectSpotCategoryFeature.Action)
    case selectPhoto(SelectSpotImageFeature.Action)
    case complete(SpotSuggestionCompleteFeature.Action)
    case delegate(Delegate)
    
    @CasePathable
    public enum Delegate: Equatable {
      case moveLocation(SelectSpotLocationFeature.Action.Delegate)
      case writeName(SelectSpotNameFeature.Action.Delegate)
      case selectKind(SelectSpotCategoryFeature.Action.Delegate)
      case selectPhoto(SelectSpotImageFeature.Action.Delegate)
      case complete(SpotSuggestionCompleteFeature.Action.Delegate)
    }
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.moveLocation, action: \.moveLocation) {
      SelectSpotLocationFeature()
    }
    Scope(state: \.writeName, action: \.writeName) {
      SelectSpotNameFeature()
    }
    Scope(state: \.selectKind, action: \.selectKind) {
      SelectSpotCategoryFeature()
    }
    Scope(state: \.selectPhoto, action: \.selectPhoto) {
      SelectSpotImageFeature()
    }
    Scope(state: \.complete, action: \.complete) {
      SpotSuggestionCompleteFeature()
    }
    
    Reduce { state, action in
      switch action {
        /// MoveLocationFeature의 delegate를 부모로 전달
      case let .moveLocation(.delegate(delegateAction)):
        return .send(.delegate(.moveLocation(delegateAction)))
        
        /// WriteNameFeature의 delegate를 부모로 전달
      case let .writeName(.delegate(delegateAction)):
        return .send(.delegate(.writeName(delegateAction)))
        
        /// SelectKindFeature의 delegate를 부모로 전달
      case let .selectKind(.delegate(delegateAction)):
        return .send(.delegate(.selectKind(delegateAction)))
        
        /// SelectPhotoFeature의 delegate를 부모로 전달
      case let .selectPhoto(.delegate(delegateAction)):
        return .send(.delegate(.selectPhoto(delegateAction)))
        
      case let .complete(.delegate(delegateAction)):
        return .send(.delegate(.complete(delegateAction)))
        
        /// 일반 Action들은 각각의 Scope에서 처리되므로 여기서는 패스
      case .moveLocation:
        return .none
        
      case .writeName:
        return .none
        
      case .selectKind:
        return .none
        
      case .selectPhoto:
        return .none
        
      case .complete:
        return .none
        
      case .delegate:
        return .none
      }
    }
  }
}
