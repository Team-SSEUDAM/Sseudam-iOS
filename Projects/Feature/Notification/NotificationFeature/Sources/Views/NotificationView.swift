//
//  NotificationView.swift
//
//  Notification
//
//  Created by Jiyeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import DotLottie

public struct NotificationView: View {
  @Bindable var store: StoreOf<NotificationFeature>
  
  private let bottomPadding: CGFloat = 13
  
  public init(store: StoreOf<NotificationFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      
      if store.isLoggedIn {
        contents
      } else {
        ZStack {
          VStack(spacing: .Number0) {
            NavigationBarView
            Spacer()
          }
          requireLoginView
        }
      }
      SnackBarView
        .padding(.bottom, .tabbarHeight+bottomPadding)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var contents: some View {
    ZStack {
      VStack(spacing: .Number0) {
        NavigationBarView
        if store.data.isEmpty {
          if !store.isLoading {
            EmptyView
          }
        } else {
          NotificationItems
          Spacer()
        }
      }
      if store.isLoading {
        loadingView
      }
    }
  }
  
  @ViewBuilder
  private var EmptyView: some View {
    VStack {
      Spacer()
      Text("아직 알림이 없어요!")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Disabled)
      Spacer()
    }
  }
  
  @ViewBuilder
  private var NotificationItems: some View {
    ScrollView {
      LazyVStack(spacing: .Number0) {
        ForEach(store.data, id: \.id) { item in
          NotificationItemView(data: item) { type in
            store.send(.itemTapped(type))
          }
          
        }
      }
    }
    .refreshable {
      store.send(.refreshNotificationItems)
    }
    .onScrollGeometryChange(for: CGFloat.self, of: { geo in
      let offsetY = geo.contentOffset.y
      let contentHeight = geo.contentSize.height
      let containerHeight = geo.containerSize.height
      return contentHeight - containerHeight - offsetY
    }, action: { oldValue, newValue in
      if newValue < 200 {
        store.send(.fetchNotificationItems(isFirst: false))
      }
    })
    .padding(.bottom, .Number50)
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      title: "알림"
    )
  }
  
  @ViewBuilder
  private var SnackBarView: some View {
    SnackBar(message: $store.toastMessage) {
      store.send(.showToastMessage(nil))
    }
    .padding(.horizontal, .Number16)
  }
  
  
  @ViewBuilder
  private var requireLoginView: some View {
    VStack(alignment: .center, spacing: .Number16) {
      Spacer()
      Text("로그인이 필요해요")
        .font(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
      Text("로그인하면 제보 내역에 대한 알림을 받을 수 있어요.")
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
  private var loadingView: some View {
    ZStack {
      Color.black.opacity(0.001)
        .ignoresSafeArea()
      DotLottieAnimation(
        fileName: LottieSet.dot_loading.name,
        config: AnimationConfig(autoplay: true, loop: true)
      )
      .view()
      .frame(width: .Number100, height: .Number100)
    }
  }
  
}


