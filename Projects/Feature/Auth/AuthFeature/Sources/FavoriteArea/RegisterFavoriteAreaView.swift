//
//  FavoriteAreaView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct RegisterFavoriteAreaView: View {
  
  @Bindable var store: StoreOf<RegisterFavoriteAreaFeature>
  
  public init(store: StoreOf<RegisterFavoriteAreaFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      NavigationBar(backContent:  {
        TouchArea(image: .leftChevron) {
          store.send(.dismiss)
        }
      })
      VStack(alignment: .leading)  {
        Text("관심 지역을 입력해주세요")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
          .padding(.vertical, .Number8)
        CustomTextField(
          placeholder: "동명(읍, 면)으로 검색",
          text: $store.area.removeDuplicates(),
          state: .constant(.accent),
          isFocused: $store.focusKeyboard
        )
        Spacer()
        PrimaryButton(
          title: "완료",
          size: .large,
          state: .normal
        ) { }
        .padding(.vertical, .Number16)
      }
      .padding(.horizontal, .Number16)
    }
    .navigationBarHidden(true)
    .onAppear {
      store.send(.onAppear)
    }
    
  }
  
}
