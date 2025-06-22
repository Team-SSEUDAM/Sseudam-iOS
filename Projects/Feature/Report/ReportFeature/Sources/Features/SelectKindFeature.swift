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
  
  public enum SelectedKind: Equatable {
    case normal, recycle
  }
  
  @ObservableState
  public struct State: Equatable {
    public var selectedNormal: CheckBoxButtonState = .normal
    public var selectedRecycle: CheckBoxButtonState = .normal
    
    public init() {
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case selectedKind(SelectedKind)
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .selectedKind(kind):
        state.selectedNormal = kind == .normal ? .selected : .normal
        state.selectedRecycle = kind == .recycle ? .selected : .normal
        return .none
      default: return .none
      }
    }
  }
}
