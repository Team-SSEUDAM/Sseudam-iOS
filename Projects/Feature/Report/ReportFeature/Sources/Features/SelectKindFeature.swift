//
//  SelectKindFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture


@Reducer
public struct SelectKindFeature {
  
  public init() {
    
  }
  
  public enum SelectedKind: String, Equatable {
    case normal = "GENERAL"
    case recycle = "RECYCLE"
  }
  
  @ObservableState
  public struct State: Equatable {
    public var selectedNormal: CheckBoxButtonState = .normal
    public var selectedRecycle: CheckBoxButtonState = .normal
    public var isEnabled: Bool = false
    public init() {
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case delegate(Delegate)
    case binding(BindingAction<State>)
    case selectedKind(SelectedKind)
    
    public enum Delegate: Equatable {
      case didSelectKind(String)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .selectedKind(kind):
        state.selectedNormal = kind == .normal ? .selected : .normal
        state.selectedRecycle = kind == .recycle ? .selected : .normal
        state.isEnabled = true
        return .send(.delegate(.didSelectKind(kind.rawValue)))
        
      default: return .none
      }
    }
  }
}
