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

public struct NotificationView: View {
  @Bindable var store: StoreOf<NotificationFeature>

  public init(store: StoreOf<NotificationFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      
      if store.isLoggedIn {
        VStack(spacing: .Number0) {
          NavigationBarView
          NotificationItems
          Spacer()
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
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var NotificationItems: some View {
    ScrollView {
      LazyVStack(spacing: .Number0) {
        ForEach(0..<10) { _ in
          NotificationItemView()
        }
      }
    }
    .padding(.bottom, .Number50)
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      title: "알림"
    )
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
  
}


