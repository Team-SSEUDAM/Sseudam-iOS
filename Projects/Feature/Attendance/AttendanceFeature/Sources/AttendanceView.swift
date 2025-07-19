//
//  AttendanceView.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture

public struct AttendanceView: View {
  @Bindable var store: StoreOf<AttendanceFeature>

  public init(store: StoreOf<AttendanceFeature>) {
    self.store = store
  }

  public var body: some View {
    EmptyView()
  }
}


