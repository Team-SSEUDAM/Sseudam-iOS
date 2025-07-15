//
//  MyPetView.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct MyPetView: View {
  @Bindable var store: StoreOf<MyPetFeature>
  
  public init(store: StoreOf<MyPetFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      ContentView
        .onAppear() {
          store.send(.onAppear)
        }
    } destination: { store in
      switch store.case {
      case let .petDetail(store):
        MyPetDetailView(store: store)
      }
    }
    .onChange(of: store.path) { oldValue, newValue in
      /// 네비게이션 path의 `newValue`가 0이 되면 탭바는 등장
      if newValue.count == 0 { store.send(.delegate(.needToHiddenTabBar(false))) }
    }
    .transaction { transaction in
      transaction.disablesAnimations = false
    }
    
  }
  
  @ViewBuilder
  private var ContentView: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      if store.isLoggedIn { MainView }
      else { RequireLoginView }
    }
  }
  
  @ViewBuilder
  private var MainView: some View {
    ColorSet.Background.Primary
      .overlay(
        CustomBottomSheet(
          minHeight: 200,
          maxHeight: 500
        ) {
          Text("작은 시트")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.yellow)
          PrimaryButton(
            title: .constant("네비게이션"),
            size: .large,
            state: .constant(.normal)
          ) {
            store.send(.petDetailButtonTapped)
          }
        } largeContent: {
          Text("큰 시트")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.orange)
        }
      )
    
  }
  
  @ViewBuilder
  private var RequireLoginView: some View {
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


