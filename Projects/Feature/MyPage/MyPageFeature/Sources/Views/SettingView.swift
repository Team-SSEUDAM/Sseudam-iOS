//
//  SettingView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SettingView: View {
  @Bindable var store: StoreOf<SettingFeature>

  public init(store: StoreOf<SettingFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(spacing: .Number0) {
        NavigationBarView
        settingListView
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron, {
          store.send(.pop)
        })
      },
      title: "설정"
    )
    
  }
  
  @ViewBuilder
  private var settingListView: some View {
    ServiceSection
    BorderView(size: .xlarge)
    NotiSection
    BorderView(size: .xlarge)
    EtcSection
    if store.isLoggedIn {
      BorderView(size: .xlarge)
      AuthSection
    }
  }
  
  @ViewBuilder
  private var ServiceSection: some View {
    SettingItemListView(title: "서비스") {
      SettingItemView(item: .suggestion, trailingContent: {})
      SettingItemView(item: .feedback, trailingContent: {})
    }
  }
  
  @ViewBuilder
  private var NotiSection: some View {
    SettingItemListView(title: "푸시 알림") {
      SettingItemView(item: .notification, trailingContent: {
        Toggle(isOn: $store.isNotiOn) {
          
        }
        .customToggleStyle()
      })
    }
  }
  
  @ViewBuilder
  private var EtcSection: some View {
    SettingItemListView(title: "기타") {
      SettingItemView(
        item: .update,
        subTitle: "v2.0/v1.0",
        trailingContent: {
          Text(true ? "업데이트" : "최신버전 사용 중")
            .font(FontSet.Label.label2)
            .foregroundStyle(ColorSet.Text.Accent)
        }
      )
      SettingItemView(item: .serviceTerm)
      SettingItemView(item: .privacyTerm)
    }
  }
  
  @ViewBuilder
  private var AuthSection: some View {
    SettingItemListView() {
      SettingItemView(item: .logout)
      SettingItemView(item: .withdraw)
    }
  }
}
