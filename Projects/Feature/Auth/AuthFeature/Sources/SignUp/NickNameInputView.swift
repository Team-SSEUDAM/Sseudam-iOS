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
    VStack {
      Text("닉네임을 입력해주세요")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.vertical, .Number8)
        .padding(.horizontal, .Number16)
      
      CustomTextField(
        placeholder: "닉네임",
        text: $store.nickaname,
        state: .constant(.normal)
      ) {
        Text("2~12자까지 입력할 수 있어요")
      }
      
      Spacer()
      PrimaryButton(title: "완료", size: .large, state: .normal) {
        
      }
      .padding(.vertical, .Number16)
    }
    .padding(.horizontal, .Number16)
  }
}
