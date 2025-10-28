//
//  TrashThrowConfirmFeature.swift
//  NotificationFeature
//
//  Created by Jiyeon on 10/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import TrashSpotDomainInterface
import UserDefaults

@Reducer
public struct TrashThrowConfirmFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var trashDetail: TrashSpotDetail
    var userName: String
    
    public init(trashDetail: TrashSpotDetail) {
      self.trashDetail = trashDetail
      self.userName = UserDefaultsKeys.username ?? ""
    }
  }
  
  public enum Action: Equatable {
    case showButtonTapped
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showTrashDetail(TrashSpotDetail)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .showButtonTapped:
        return .send(.delegate(.showTrashDetail(state.trashDetail)))
      default: return .none
      }
    }
  }
  
}
