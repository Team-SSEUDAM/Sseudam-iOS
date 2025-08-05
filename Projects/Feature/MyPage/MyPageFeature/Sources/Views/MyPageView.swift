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
        VStack(spacing: .Number0) {
          NavigationBarView
          PageScrollView
        }
      } else {
        ZStack {
          VStack(spacing: .Number0) {
            NavigationBarView
            Spacer()
          }
          requireLoginView
        }
      }
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
  private var PageScrollView: some View {
    HeaderPageScrollView(displaysSymbols: false) {
        UserInfoView
          .frame(maxWidth: .infinity)
          .background(ColorSet.Background.Primary)
      } pageLabels: {
        PageLabel(title: "제보한 내역")
        PageLabel(title: "버린 내역")
      } pages: {
        DummySuggestList
        DummyThrownList
      } onRefresh: {
        print("Refresh triggered")
      }
  }
  
  @ViewBuilder
  private var UserInfoView: some View {
    VStack(alignment: .center, spacing: .Number12) {
      Icon(image: .addSpot, size: .Number72)
      HStack(alignment: .center, spacing: .Number4) {
        Text("{store.userName}")
          .font(FontSet.Heading.heading3)
          .foregroundStyle(ColorSet.Text.Primary)
        Icon(
          image: .edit,
          renderingMode: .template,
          color: ColorSet.Icon.Tertiary
        )
        .onTapGesture {
          print("Edit Profile Tapped")
        }
      }
    }
    .padding(.vertical, .Number28)
    .padding(.horizontal, .Number16)
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
  
  @ViewBuilder
  private var DummySuggestList: some View {
    LazyVStack(spacing: .Number0) {
      ForEach(0..<10) { index in
        SuggestCell()
      }
      .background(ColorSet.Background.Primary)
    }
  }
  
  @ViewBuilder
  private var DummyThrownList: some View {
    LazyVStack(spacing: .Number0) {
      ForEach(0..<10) { index in
        ThrownCell()
      }
      .background(ColorSet.Background.Primary)
    }
  }
}


