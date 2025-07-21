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
    public let continuitityCount: Int = 2
    public let isContinuity: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case confirmButtonTapped
    
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .confirmButtonTapped:
        return .send(.dismiss)
        
      case .dismiss:
        return .send(.delegate(.dismiss))
        
        default: return .none
      }
    }
  }
}
