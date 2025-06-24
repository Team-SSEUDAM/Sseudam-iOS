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
    NavigationStack {
      VStack(alignment: .leading) {
        Text("닉네임을 입력해주세요")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
          .padding(.vertical, .Number8)
        
        CustomTextField(
          placeholder: "닉네임",
          text: $store.nickname.removeDuplicates(),
          state: .constant(store.nicknameValid.textFieldState),
          isFocused: $store.focusKeyboard
        ) {
          Text(store.nicknameValid.text)
        }
        
        Spacer()
        PrimaryButton(
          title: "완료",
          size: .large,
          state: store.nicknameValid.isValid ? .normal : .disabled
        ) {
          
        }
        .padding(.vertical, .Number16)
      }
      .padding(.horizontal, .Number16)
      .padding(.top, .Number48)
      .onAppear {
        store.send(.onAppear)
      }
    }
  }
}
