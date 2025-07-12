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
    SettingItemListView(title: "서비스", items: []) {
      SettingItemView(item: .suggestion, trailingContent: {})
      SettingItemView(item: .feedback, trailingContent: {})
    }
    
    BorderView(size: .xlarge)
    SettingItemListView(title: "푸시 알림", items: []) {
      SettingItemView(item: .notification, trailingContent: {
        Toggle(isOn: $store.isNotiOn) {
          
        }
        .customToggleStyle()
      })
    }
    
    BorderView(size: .xlarge)
    SettingItemListView(title: "기타", items: []) {
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
    
    if store.isLoggedIn {
      BorderView(size: .xlarge)
      SettingItemListView(items: []) {
        SettingItemView(item: .logout)
        SettingItemView(item: .withdraw)
      }
    }
  }
}
