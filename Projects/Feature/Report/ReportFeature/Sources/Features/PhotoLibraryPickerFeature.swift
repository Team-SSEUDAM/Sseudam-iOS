//
//  PhotoLibraryPickerFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct PhotoLibraryPickerFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: Equatable {
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case photoSelected(UIImage)
      case cancelled
    }
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      return .none
    }
  }
}

