//
//  MyPageView.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import SwiftUI
import DesignKit
import ComposableArchitecture
import UserDefaults

public struct MyPageView: View {
  @Bindable var store: StoreOf<MyPageFeature>

  public init(store: StoreOf<MyPageFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
        content
      } destination: { store in
        switch store.case {
        case let .setting(store):
          SettingView(store: store)
        }
      }
      .onAppear {
        store.send(.onAppear)
      }
      .onChange(of: store.path) { oldValue, newValue in
        if newValue.count == 0 {
          store.send(.checkLoggedIn)
          store.send(.delegate(.hiddenTabBar(false)))
        }
      }
      .transaction { transaction in
        transaction.disablesAnimations = false
      }

  }
  
  @ViewBuilder
  private var content: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      if store.isLoggedIn {
        NavigationContent
      } else {
        ZStack {
          NavigationContent
          requireLoginView
        }
      }
    }
  }
  
  @ViewBuilder
  private var NavigationContent: some View {
    VStack {
      NavigationBarView
      Spacer()
    }
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      title: "마이페이지",
      closeContent: {
        TouchArea(image: .settings) {
          store.send(.settingButtonTapped)
        }
      }
    )
  }

  
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
          store.send(.requestLogin)
        }
        .frame(width: 129)
      
      Spacer()
    }
  }
}


