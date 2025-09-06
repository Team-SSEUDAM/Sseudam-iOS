//
//  SuggestionChildFeature.swift
//  SuggestionFeature
//
//  Created by 조용인 on 7/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Utility
import NMReverseGeocodingDomainInterface
import SuggestionDomainInterface

import SelectSpotImageFeature
import SelectSpotCategoryFeature
import SelectSpotNameFeature
import SelectSpotLocationFeature
import SpotSuggestionCompleteFeature

// MARK: - Child Reducer
@Reducer
public struct SuggestionChildFeature {
  
  @ObservableState
  public struct State: Equatable {
    var moveLocation: SelectSpotLocationFeature.State = SelectSpotLocationFeature.State()
    var writeName: SelectSpotNameFeature.State = SelectSpotNameFeature.State()
    var selectKind: SelectSpotCategoryFeature.State = SelectSpotCategoryFeature.State()
    var selectPhoto: SelectSpotImageFeature.State = SelectSpotImageFeature.State()
    var complete: SpotSuggestionCompleteFeature.State = SpotSuggestionCompleteFeature.State()
    
    public init(
      _ initLocation: Coordinates? = nil
    ) {
      self.moveLocation = SelectSpotLocationFeature.State(initLocation)
    }
  }
  
  public enum Action: Equatable {
    case moveLocation(SelectSpotLocationFeature.Action)
    case writeName(SelectSpotNameFeature.Action)
    case selectKind(SelectSpotCategoryFeature.Action)
    case selectPhoto(SelectSpotImageFeature.Action)
    case complete(SpotSuggestionCompleteFeature.Action)
    case delegate(Delegate)
    case mixPanel(MixPanel)
    
    @CasePathable
    public enum Delegate: Equatable {
      case moveLocation(SelectSpotLocationFeature.Action.Delegate)
      case writeName(SelectSpotNameFeature.Action.Delegate)
      case selectKind(SelectSpotCategoryFeature.Action.Delegate)
      case selectPhoto(SelectSpotImageFeature.Action.Delegate)
      case complete(SpotSuggestionCompleteFeature.Action.Delegate)
    }
    
    public enum MixPanel: Equatable {
      case moveLocation(SelectSpotLocationFeature.Action.MixPanel)
      case selectPhoto(SelectSpotImageFeature.Action.MixPanel)
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
        
      case let .moveLocation(.mixPanel(mixPanelAction)):
        return .send(.mixPanel(.moveLocation(mixPanelAction)))
        
        /// WriteNameFeature의 delegate를 부모로 전달
      case let .writeName(.delegate(delegateAction)):
        return .send(.delegate(.writeName(delegateAction)))
        
        /// SelectKindFeature의 delegate를 부모로 전달
      case let .selectKind(.delegate(delegateAction)):
        return .send(.delegate(.selectKind(delegateAction)))
        
        /// SelectPhotoFeature의 delegate를 부모로 전달
      case let .selectPhoto(.delegate(delegateAction)):
        return .send(.delegate(.selectPhoto(delegateAction)))
        
      case let .selectPhoto(.mixPanel(mixPanelAction)):
        return .send(.mixPanel(.selectPhoto(mixPanelAction)))
        
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
        
      case .mixPanel:
        return .none
      }
    }
  }
}
