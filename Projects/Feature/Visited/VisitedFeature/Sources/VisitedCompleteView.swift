//
//  VisitedCompleteView.swift
//  VisitedFeature
//
//  Created by Jiyeon on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie

public struct VisitedCompleteView: View {
  @Bindable var store: StoreOf<VisitedCompleteFeature>
  @State private var animateButton: Bool = false
  
  public init(store: StoreOf<VisitedCompleteFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .top) {
      ColorSet.Background.Primary
      pointView
      mainContentView
      bottomView
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var mainContentView: some View {
    VStack {
      Spacer()
      ZStack {
        completeView
        firstVisitView
      }
      
    }
    .padding(.horizontal, .Number16)
  }
  
  private var pointView: some View {
    VStack {
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
          .opacity(store.showLevelBar ? 1 : 0)
          .animation(.easeIn(duration: 0.1), value: store.showLevelBar)
        }
      }
      .padding(.top, .Number20)
      Spacer()
    }
  }
  
  @ViewBuilder
  private var completeView: some View {
    ZStack {
      ConfettiView
      VStack(spacing: .Number16) {
        Spacer()
        DotLottieView(dotLottie: store.animationState.success)
          .frame(width: 120, height: 120)
        Text("방문 인증이 완료되었어요")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
        Spacer()
      }
    }
    .opacity(store.isShowFirstVisitMessage ? 0 : 1)
    .animation(.easeInOut(duration: 0.4), value: store.isShowFirstVisitMessage)
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var firstVisitView: some View {
    VStack(alignment: .center) {
      Spacer()
      Text("오늘 첫 인증이군요!\n보너스로 2쓰담을 더 드릴게요")
        .multilineTextAlignment(.center)
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .offset(y: store.isShowFirstVisitMessage ? 0 : 20)
        .opacity(store.isShowFirstVisitMessage ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: store.isShowFirstVisitMessage)
              
      Spacer()
    }

  }
  
  @ViewBuilder
  private var ConfettiView: some View {
    if store.isShowConfetti {
      VStack(alignment: .center, spacing: .Number0) {
        DotLottieView(dotLottie: store.animationState.confetti)
          .scaleEffect(2.5)
          .frame(height: 600)
          .clipped()
        Spacer()
      }
    }
  }
  
  @ViewBuilder
  private var bottomView: some View {
    VStack {
      SnackBar(attributedMessage: $store.toastMessage) {
        store.send(.resetToastMessage)
      }
      
      if animateButton {
        PrimaryButton(
          title: .constant("확인"),
          state: .constant(.normal)
        ) {
          store.send(.comfirmButtonTapped)
        }
        .padding(.vertical, .Number16)
      }
    }
    .padding(.horizontal, .Number16)
    .onChange(of: store.isShowButton) { oldValue, newValue in
      if newValue {
        withAnimation(.easeIn(duration: 0.3)) {
          animateButton = true
        }
      }
    }
  }
  
}


