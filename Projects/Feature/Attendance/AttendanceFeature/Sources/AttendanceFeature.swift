//
//  AttendanceFeature.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import ComposableArchitecture

@Reducer
public struct AttendanceFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    public let attendanceStatus: AttendanceStatus = .success(day: 3)
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case confirmButtonTapped
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        default: return .none
      }
    }
  }
}
