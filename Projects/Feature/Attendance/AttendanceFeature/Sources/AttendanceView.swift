//
//  AttendanceView.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import Foundation
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
        bottomView
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var pointView: some View {
    HStack {
      Spacer()
      
      if let petInfo = store.petInfo {
        LevelBar(
          currentLevel: petInfo.levelType,
          currentPoint: petInfo.currentPoint,
          addPoint: store.sseudamPoint.point,
          maxLevelPoint: petInfo.goalPoint,
          startAnimation: $store.startLevelAnimation
        )
        .opacity(store.attendanceStatus == .fail ? 0 : 1)
        .animation(.easeIn(duration: 0.1), value: store.attendanceStatus != .fail)
      }
    }
    .padding(.top, .Number20)
  }
  
  @ViewBuilder
  private var attendanceStateView: some View {
    ZStack{
      VStack(spacing: .Number24){
        Spacer()
        VStack(spacing: .Number16) {
          titleView
          descriptionView
        }
        AttendanceTrackerView(
          continuityCount: store.continuityCount,
          isContinuing: store.isContinuity
        )
        Spacer()
      }
      VStack {
        Spacer()
        SnackBar(attributedMessage: $store.toastMessage) {
          store.send(.showToastMessage(nil))
        }
      }
      .padding(.horizontal, .Number16)
    }
  }
  
  @ViewBuilder
  private var titleView: some View {
    Group {
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
        Text(store.attendanceStatus.title)
          .multilineTextAlignment(.center)
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
      }
    }
      .offset(y: store.showTitle ? 0 : 20)
      .opacity(store.showTitle ? 1 : 0)
      .animation(
        store.showTitle ? .easeOut(duration: 0.4).delay(0.2) : nil,
        value: store.showTitle
      )
  }
  
  @ViewBuilder
  private var descriptionView: some View {
    Text(store.attendanceStatus.description)
      .multilineTextAlignment(.center)
      .font(FontSet.Body.body3)
      .foregroundStyle(ColorSet.Text.Secondary)
      .offset(y: store.showDescription ? 0 : 20)
      .opacity(store.showDescription ? 1 : 0)
      .animation(
        store.showDescription ? .easeOut(duration: 0.4).delay(0.2) : nil,
        value: store.showDescription
      )
  }
  
  @ViewBuilder
  private var bottomView: some View {
    
    PrimaryButton(
      title: $store.buttonTitle,
      state: .constant(.normal)
    ) {
      if store.attendanceStatus == .fail {
        store.send(.handleContinuityFail)
      } else {
        store.send(.confirmButtonTapped)
      }
    }
    .padding(.Number16)
    .opacity(store.showButton ? 1 : 0)
    .animation(.easeIn(duration: 0.3), value: store.showButton)
    .allowsHitTesting(store.showButton)
    
  }
}


