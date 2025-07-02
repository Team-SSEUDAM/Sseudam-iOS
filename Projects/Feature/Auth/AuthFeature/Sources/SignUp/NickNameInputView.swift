//
//  NickNameInputView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct NickNameInputView: View {
  
  @Bindable var store: StoreOf<NickNameInputFeature>
  
  public init(store: StoreOf<NickNameInputFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        content
          .background(.white)
      } destination: { store in
        switch store.case {
        case .registerArea(let store):
          RegisterFavoriteAreaView(store: store)
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
      .navigationBarHidden(true)
    }
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading) {
      Text("닉네임을 입력해주세요")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.vertical, .Number8)
      
      NicknameTextField
      Spacer()
      SnackBar(message: $store.errorToastMessage, {})
      CompleteButton
    }
    .background(.white)
    .padding(.horizontal, .Number16)
    .padding(.top, .Number48)
  }
  
  @ViewBuilder
  private var CompleteButton: some View {
    PrimaryButton(
      title: .constant("다음"),
      size: .large,
      state: store.nicknameValid.isValid ? .constant(.normal) : .constant(.disabled)
    ) {
      store.send(.completeButtonTapped)
    }
    .padding(.vertical, .Number16)
  }
  
  @ViewBuilder
  private var NicknameTextField: some View {
    
    CustomTextField(
      placeholder: "닉네임",
      text: $store.nickname.removeDuplicates(),
      state: .constant(store.nicknameValid.textFieldState),
      isFocused: $store.focusKeyboard
    ) {
      Text(store.nicknameValid.text)
    }
  }
}
