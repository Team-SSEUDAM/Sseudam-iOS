//
//  MyPageRootView.swift
//  Sseudam
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import AuthFeature
import DesignKit

struct MyPageRootView: View {
  
  @Bindable var store: StoreOf<MyPageRootFeature>
  
  init(store: StoreOf<MyPageRootFeature>) {
    self.store = store
  }
  
  var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        if !store.state.isLoggedIn {
          requireLoginView
        } else {
          Text("로그인~")
            .foregroundStyle(ColorSet.Text.Primary)
        }
      }
    }
  }
  
  // TODO: - mypage 모듈 안으로 옮기기
  @ViewBuilder
  private var requireLoginView: some View {
    VStack(alignment: .center, spacing: .Number16) {
      Spacer()
      Text("로그인이 필요해요")
        .font(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
      Text("로그인하면 나의 제보, 인증 내역을 관리할 수 있어요.")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
      PrimaryButton(
        title: .constant("로그인하러 가기"),
        size: .large,
        state: .constant(.normal)
      ) {
          store.send(.requestLogin(true, .mypage))
        }
        .frame(width: 129)
      
      Spacer()
    }
  }
}
