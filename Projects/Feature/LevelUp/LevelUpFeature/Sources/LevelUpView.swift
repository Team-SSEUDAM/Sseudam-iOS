//
//  LevelUpView.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie

public struct LevelUpView: View {
  @Bindable var store: StoreOf<LevelUpFeature>

  public init(store: StoreOf<LevelUpFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
      ZStack {
        LevelUpView
        BottomView
      }
    }
    .background(ColorSet.Background.Primary.ignoresSafeArea())
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var LevelUpView: some View {
    ZStack{
      ColorSet.Background.Primary
      ConfettiView
      VStack(alignment: .center, spacing: .Number16) {
        Spacer()
        Image(
          asset: CatImageSet.imgae(
            level: store.catLevel,
            interaction: false,
            type: store.petInfo.season
          )
        )
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .frame(height: .Number200)
        
        Text("축하해요!")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
        HStack(spacing: .Number0) {
          Text(store.catLevel.levelText + " " + store.petInfo.nickname)
            .foregroundStyle(ColorSet.Text.Accent)
          Text("로 레벨업했어요")
            .foregroundStyle(ColorSet.Text.Secondary)
        }
        .font(FontSet.Body.body3)
        
        Spacer()
      }
    }
  }
  
  @ViewBuilder
  private var BottomView: some View {
    VStack {
      Spacer()
      PrimaryButton(
        title: .constant("확인"),
        state: .constant(.normal)
      ) {
        store.send(.confirmButtonTapped)
      }
      .padding(.Number16)
      .opacity(store.showButton ? 1 : 0)
      .animation(.easeIn(duration: 0.3), value: store.showButton)
      .allowsHitTesting(store.showButton)
    }
  }
  
  @ViewBuilder
  private var ConfettiView: some View {
    if store.showConfetti {
      VStack(alignment: .center, spacing: .Number0) {
        DotLottieView(dotLottie: store.animationState.confetti)
          .scaleEffect(2.5)
          .frame(height: 600)
          .clipped()
        Spacer()
      }
    }
  }
  
}


