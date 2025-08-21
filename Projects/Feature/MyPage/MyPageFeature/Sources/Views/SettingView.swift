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
        SnackBarView
      }
      AlertView
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      store.send(.onAppear)
    }
  }
  
}

extension SettingView {
  
  @ViewBuilder
  private var SnackBarView: some View {
    SnackBar(message: $store.toastMessage) {
      store.send(.showToastMessage(nil))
    }
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var AlertView: some View {
    if let alertType = store.alertType {
      Alert(
        type: alertType,
        closeAction: {
          store.send(.alertCancelTapped)
        },
        acceptAction: {
          store.send(.alertAcceptTapped(alertType))
        }
      )
    }
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
      SettingItemView(item: .feedback) {
        store.send(.feedback)
      }
    }
  }
  
  @ViewBuilder
  private var NotiSection: some View {
    SettingItemListView(title: "푸시 알림") {
      SettingItemView(item: .notification, trailingContent: {
        Text("설정으로 이동")
          .font(FontSet.Label.label2)
          .foregroundStyle(ColorSet.Text.Accent)
          .onTapGesture {
            store.send(.moveToNotiSetting)
          }
      })
    }
  }
  
  @ViewBuilder
  private var EtcSection: some View {
    SettingItemListView(title: "기타") {
      SettingItemView(
        item: .update,
        subTitle: store.version,
        trailingContent: {
          Text(store.isNeedUpdate ? "업데이트" : "최신버전 사용 중")
            .font(FontSet.Label.label2)
            .foregroundStyle(ColorSet.Text.Accent)
            .onTapGesture {
              store.send(.appstore)
            }
        }
      )
      SettingItemView(item: .serviceTerm) {
        store.send(.serviceTerm)
      }
      SettingItemView(item: .privacyTerm) {
        store.send(.privacyTerm)
      }
    }
  }
  
  @ViewBuilder
  private var AuthSection: some View {
    SettingItemListView() {
      SettingItemView(item: .logout) {
        store.send(.logout)
      }
      SettingItemView(item: .withdrawal) {
        store.send(.withdrawal)
      }
    }
  }
}
