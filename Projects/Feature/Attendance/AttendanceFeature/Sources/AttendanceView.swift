//
//  AttendanceView.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct AttendanceView: View {
  @Bindable var store: StoreOf<AttendanceFeature>

  public init(store: StoreOf<AttendanceFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
      VStack {
        pointView
        attendanceStateView
        PrimaryButton(
          title: .constant("확인"),
          state: .constant(.normal)
        ) {
          store.send(.confirmButtonTapped)
        }
        .padding(.Number16)
      }
    }
  }
  
  @ViewBuilder
  private var pointView: some View {
    Spacer()
      .frame(height: .Number48)
  }
  
  @ViewBuilder
  private var attendanceStateView: some View {
    VStack(spacing: .Number24){
      Spacer()
      VStack(spacing: .Number16) {
        titleView
        Text(store.attendanceStatus.description)
          .multilineTextAlignment(.center)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
      }
      AttendanceTrackerView(continuityCount: store.continuitityCount, isContinuing: store.isContinuity)
      Spacer()
    }
  }
  
  @ViewBuilder
  private var titleView: some View {
    
    switch store.attendanceStatus {
    case .success, .continuedSuccess:
      HStack(spacing: .Number0) {
        Text("연속  ").foregroundStyle(ColorSet.Text.Primary)
        Text(store.attendanceStatus.title)
          .foregroundStyle(ColorSet.Text.Accent)
        Text(" 출석 완료!")
          .foregroundStyle(ColorSet.Text.Primary)
      }
      .multilineTextAlignment(.center)
      .font(FontSet.Heading.heading1)
    default:
      Text(store.attendanceStatus.description)
        .multilineTextAlignment(.center)
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
    }
  }
}


