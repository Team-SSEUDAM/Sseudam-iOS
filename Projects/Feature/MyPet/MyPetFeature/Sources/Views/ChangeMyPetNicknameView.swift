//
//  ChangeMyPetNicknameView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie

public struct ChangeMyPetNicknameView: View {
  @Bindable var store: StoreOf<ChangeMyPetNicknameFeature>
  
  public init(store: StoreOf<ChangeMyPetNicknameFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBarView
      VStack(alignment: .leading) {
        CustomTextField(
          placeholder: "",
          text: $store.name,
          state: .constant(store.textFieldState),
          isFocused: $store.isFocused
        ) {
          Text(store.errorMessage)
        }
        .padding(.horizontal, .Number16)
        .padding(.vertical, .Number24)
        Spacer()
      }
      
      PrimaryButton(
        loadingView: {
          DotLottieAnimation(
            fileName: LottieSet.loading.name,
            config: AnimationConfig(autoplay: true, loop: true)
          ).view()
        },
        isLoading: $store.isLoading,
        title: .constant("변경하기"),
        size: .large,
        state: $store.buttonState
      ) {
        store.send(.changeNicknameButtonTapped)
      }
      .padding(.Number16)
    }
    .background(ColorSet.Background.Primary)
    .navigationBarBackButtonHidden(true)
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron) {
          store.send(.backButtonTapped)
        }
      },
      title: "펫 이름 변경"
    )
  }
}
