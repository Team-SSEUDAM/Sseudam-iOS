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

  public init(store: StoreOf<VisitedCompleteFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .top) {
      ColorSet.Background.Primary
      ConfettiView
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
      completeView
      
    }
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var completeView: some View {
    
    VStack(spacing: .Number16) {
      Spacer()
      // TODO: - 아이콘 변경 필요
      //      Icon(image: .check, size: .Number64)
      DotLottieAnimation(
        fileName: LottieSet.success.name,
        config: AnimationConfig(autoplay: true, loop: false)
      )
      .view()
      .frame(width: 120, height: 120)
      Text("방문 인증이 완료되었어요")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
      Spacer()
    }
    .padding(.horizontal, .Number16)
    
    
    
  }
  
  @ViewBuilder
  private var ConfettiView: some View {
    VStack(alignment: .center, spacing: .Number0) {
      DotLottieAnimation(
        fileName: LottieSet.confetti.name,
        config: AnimationConfig(autoplay: true, loop: false)
      )
      .view()
      .scaleEffect(2.5)
      .frame(height: 600)
      .clipped()
      Spacer()
    }
  }
  
  @ViewBuilder
  private var bottomView: some View {
    VStack {
      Spacer()
      SnackBar(attributedMessage: $store.toastMessage) {
        store.send(.resetToastMessage)
      }
      PrimaryButton(
        title: .constant("확인"),
        state: .constant(.normal)
      ) {
        store.send(.comfirmButtonTapped)
      }
      .padding(.vertical, .Number16)
    }
    .padding(.horizontal, .Number16)
  }
  
  
  
  
}


