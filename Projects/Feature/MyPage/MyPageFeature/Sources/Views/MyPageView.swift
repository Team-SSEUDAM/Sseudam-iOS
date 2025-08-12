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
        .padding(.bottom, .Number50)
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
      GeometryReader { geo in
        let height = geo.size.height - .Number320
        VStack(alignment: .leading, spacing: .Number0) {
          SuggestionFilterView { type in
            store.send(.suggestionList(.filterTapped(type)))
          }
          .padding(.Number16)
          SuggestList(height: height)
        }
      }
      GeometryReader { geo in
        let height = geo.size.height - .Number320
        ThrownList(height: height)
      }
    } onRefresh: {
      print("Refresh triggered")
      store.send(.refreshPage)
    }
  }
  
  @ViewBuilder
  private var UserInfoView: some View {
    VStack(alignment: .center, spacing: .Number12) {
      Icon(image: .avartar, size: .Number72)
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
  private func SuggestList(height: CGFloat) -> some View {
    LazyVStack(spacing: .Number0) {
      if let histories = store.suggestionList.filterdHistories, !histories.isEmpty {
        ForEach(histories) { history in
          if let data = store.suggestionList.suggestionsImages[history.id] {
            SuggestCell(history: history, imageData: data)
          } else {
            SuggestCell(history: history)
          }
        }
      } else {
        VStack(alignment: .center, spacing: .Number8) {
          Spacer()
            .frame(height: (height - .Number72) / 2)
          Icon(
            image: .sentimentDissatisfied,
            size: .Number40,
            renderingMode: .template,
            color: ColorSet.Icon.Tertiary
          )
          Text("제보한 내역이 없습니다.")
            .font(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .background(ColorSet.Background.Primary)
  }
  
  @ViewBuilder
  private func ThrownList(height: CGFloat) -> some View {
    LazyVStack(spacing: .Number0) {
      if let thrownList = store.thrownList.thrownList, !thrownList.isEmpty {
        ForEach(thrownList) { thrownList in
          ThrownCell(thrownList: thrownList)
        }
      } else {
        VStack(alignment: .center, spacing: .Number8) {
          Spacer()
            .frame(height: (height - .Number72) / 2)
          Icon(
            image: .sentimentDissatisfied,
            size: .Number40,
            renderingMode: .template,
            color: ColorSet.Icon.Tertiary
          )
          Text("제보한 내역이 없습니다.")
            .font(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .background(ColorSet.Background.Primary)
  }
}


