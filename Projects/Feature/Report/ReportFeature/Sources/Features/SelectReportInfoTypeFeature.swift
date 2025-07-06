//
//  SelectReportInfoTypeFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 7/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture


@Reducer
public struct SelectReportInfoTypeFeature {
  
  public init() {
    
  }
  
  public enum SelectedInfoEditType: Int, Equatable {
    case location = 1
    case name = 2
    case kind = 3
    case photo = 4
    case none = 0
  }
  
  @ObservableState
  public struct State: Equatable {
    public var selectedButtonType: CheckBoxButtonState = .normal
    public var selectedInfoType: SelectedInfoEditType = .none
    public var isEnabled: Bool = false
    public init() {
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case delegate(Delegate)
    case binding(BindingAction<State>)
    case selectedKind(SelectedInfoEditType)
    
    public enum Delegate: Equatable {
      case didSelectKind(id: Int)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case let .selectedKind(kind):
        state.selectedInfoType = kind
        return .send(.delegate(.didSelectKind(id: kind.rawValue)))
        
      default: return .none
      }
    }
  }
}
